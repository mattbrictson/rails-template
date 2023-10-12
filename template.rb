require "bundler"
require "json"
RAILS_REQUIREMENT = "~> 7.1.1".freeze
NODE_REQUIREMENTS = ["~> 16.14", ">= 18.0.0"].freeze

def apply_template!
  assert_minimum_rails_version
  assert_minimum_node_version
  assert_valid_options
  assert_postgresql
  add_template_repository_to_source_path

  if install_vite?
    self.options = options.merge(
      css: nil,
      skip_asset_pipeline: true
    )
  end

  template "Gemfile.tt", force: true

  template "README.md.tt", force: true
  remove_file "README.rdoc"

  template "example.env.tt"
  copy_file "editorconfig", ".editorconfig"
  copy_file "erb-lint.yml", ".erb-lint.yml"
  copy_file "overcommit.yml", ".overcommit.yml"
  template "node-version.tt", ".node-version", force: true
  template "ruby-version.tt", ".ruby-version", force: true

  copy_file "Thorfile"
  copy_file "Procfile"
  copy_file "package.json"

  apply "Rakefile.rb"
  apply "config.ru.rb"
  apply "bin/template.rb"
  apply "github/template.rb"
  apply "config/template.rb"
  apply "lib/template.rb"
  apply "test/template.rb"

  empty_directory_with_keep_file "app/lib"

  git :init unless preexisting_git_repo?
  empty_directory ".git/safe"

  after_bundle do
    append_to_file ".gitignore", <<~IGNORE

      # Ignore application config.
      /.env.development
      /.env.*local

      # Ignore locally-installed gems.
      /vendor/bundle/
    IGNORE

    if install_vite?
      File.rename("app/javascript", "app/frontend") if File.exist?("app/javascript")
      run_with_clean_bundler_env "bundle exec vite install"
      run "yarn remove vite-plugin-ruby"
      run "yarn add autoprefixer postcss rollup vite-plugin-rails modern-normalize"
      copy_file "postcss.config.js"
      copy_file "vite.config.ts", force: true
      apply "app/frontend/template.rb"
      rewrite_json("config/vite.json") do |vite_json|
        vite_json["test"]["autoBuild"] = false
      end
    end

    apply "app/template.rb"

    create_database_and_initial_migration
    run_with_clean_bundler_env "bin/setup"

    binstubs = %w[brakeman bundler bundler-audit erb_lint rubocop sidekiq thor]
    run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')} --force"

    remove_file "Procfile.dev" unless File.exist?("bin/dev")

    copy_file "rubocop.yml", ".rubocop.yml"
    run_rubocop_autocorrections

    template "eslintrc.js", ".eslintrc.js"
    template "prettierrc.js", ".prettierrc.js"
    template "stylelintrc.js", ".stylelintrc.js"
    add_yarn_lint_and_run_fix
    add_yarn_start_script
    simplify_package_json_deps

    append_to_file ".gitignore", "node_modules" unless File.read(".gitignore").match?(%{^/?node_modules})

    unless any_local_git_commits?
      git checkout: "-b main"
      git add: "-A ."
      git commit: "-n -m 'Set up project'"
      if git_repo_specified?
        git remote: "add origin #{git_repo_url.shellescape}"
        git push: "-u origin --all"
      end
    end
  end
end

require "fileutils"
require "shellwords"

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/mattbrictson/rails-template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

def assert_minimum_node_version
  requirements = NODE_REQUIREMENTS.map { Gem::Requirement.new(_1) }
  node_version = `node --version`.chomp rescue nil
  if node_version.nil?
    fail Rails::Generators::Error, "This template requires Node, but Node does not appear to be installed."
  end

  return if requirements.any? { _1.satisfied_by?(Gem::Version.new(node_version[/[\d.]+/])) }

  prompt = "This template requires Node #{NODE_REQUIREMENTS.join(" or ")}. "\
           "You are using #{node_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

# Bail out if user has passed in contradictory generator options.
def assert_valid_options
  valid_options = {
    skip_gemfile: false,
    skip_bundle: false,
    skip_git: false,
    skip_system_test: false,
    skip_test: false,
    skip_test_unit: false,
    edge: false
  }
  valid_options.each do |key, expected|
    next unless options.key?(key)
    actual = options[key]
    unless actual == expected
      fail Rails::Generators::Error, "Unsupported option: #{key}=#{actual}"
    end
  end
end

def assert_postgresql
  return if IO.read("Gemfile") =~ /^\s*gem ['"]pg['"]/
  fail Rails::Generators::Error, "This template requires PostgreSQL, but the pg gem isn’t present in your Gemfile."
end

def git_repo_url
  @git_repo_url ||=
    ask_with_default("What is the git remote URL for this project?", :blue, "skip")
end

def production_hostname
  @production_hostname ||=
    ask_with_default("Production hostname?", :blue, "example.com")
end

def gemfile_entry(name, version=nil, require: true, force: false)
  @original_gemfile ||= IO.read("Gemfile")
  entry = @original_gemfile[/^\s*gem #{Regexp.quote(name.inspect)}.*$/]
  return if entry.nil? && !force

  require = (entry && entry[/\brequire:\s*([\S]+)/, 1]) || require
  version = (entry && entry[/, "([^"]+)"/, 1]) || version
  args = [name.inspect, version&.inspect, ("require: false" if require != true)].compact
  "gem #{args.join(", ")}\n"
end

def ask_with_default(question, color, default)
  return default unless $stdin.tty?
  question = (question.split("?") << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

def git_repo_specified?
  git_repo_url != "skip" && !git_repo_url.strip.empty?
end

def preexisting_git_repo?
  @preexisting_git_repo ||= (File.exist?(".git") || :nope)
  @preexisting_git_repo == true
end

def any_local_git_commits?
  system("git log > /dev/null 2>&1")
end

def run_with_clean_bundler_env(cmd)
  success = if defined?(Bundler)
              if Bundler.respond_to?(:with_original_env)
                Bundler.with_original_env { run(cmd) }
              else
                Bundler.with_clean_env { run(cmd) }
              end
            else
              run(cmd)
            end
  unless success
    puts "Command failed, exiting: #{cmd}"
    exit(1)
  end
end

def run_rubocop_autocorrections
  run_with_clean_bundler_env "bin/rubocop -A --fail-level A > /dev/null || true"
  run_with_clean_bundler_env "bin/erblint --lint-all -a > /dev/null || true"
end

def create_database_and_initial_migration
  return if Dir["db/migrate/**/*.rb"].any?
  run_with_clean_bundler_env "bin/rails db:create"
  run_with_clean_bundler_env "bin/rails generate migration initial_migration"
end

def add_yarn_start_script
  return add_package_json_script(start: "bin/dev") if File.exist?("bin/dev")

  procs = ["'bin/rails s -b 0.0.0.0'"]
  procs << "'bin/vite dev'" if File.exist?("bin/vite")
  procs << "bin/webpack-dev-server" if File.exist?("bin/webpack-dev-server")

  add_package_json_script(start: "stale-dep && concurrently -i -k --kill-others-on-fail -p none #{procs.join(" ")}")
  add_package_json_script(postinstall: "stale-dep -u")
  run_with_clean_bundler_env "yarn add concurrently stale-dep"
end

def add_yarn_lint_and_run_fix
  packages = %w[
    eslint
    eslint-config-prettier
    eslint-plugin-prettier
    npm-run-all
    postcss
    prettier
    stale-dep
    stylelint
    stylelint-config-standard
    stylelint-declaration-strict-value
    stylelint-prettier
  ]
  add_package_json_script("fix": "npm-run-all fix:**")
  add_package_json_script("fix:js": "npm run -- lint:js --fix")
  add_package_json_script("fix:css": "npm run -- lint:css --fix")
  add_package_json_script("lint": "npm-run-all lint:**")
  add_package_json_script("lint:js": "stale-dep && eslint 'app/{components,frontend,javascript}/**/*.{js,jsx}'")
  add_package_json_script("lint:css": "stale-dep && stylelint 'app/{components,frontend,assets/stylesheets}/**/*.css'")
  add_package_json_script("postinstall": "stale-dep -u")
  run_with_clean_bundler_env "yarn add #{packages.map(&:shellescape).join(' ')}"
  run_with_clean_bundler_env "yarn fix"
end

def add_package_json_script(scripts)
  scripts.each do |name, script|
    run ["npm", "pkg", "set", "scripts.#{name.to_s.shellescape}=#{script.shellescape}"].join(" ")
  end
end

def simplify_package_json_deps
  rewrite_json("package.json") do |package_json|
    package_json["dependencies"] = package_json["dependencies"]
      .merge(package_json.delete("devDependencies") || {})
      .sort_by { |key, _| key }
      .to_h
  end
  run_with_clean_bundler_env "yarn install"
end

def rewrite_json(file)
  json = JSON.parse(File.read(file))
  yield(json)
  File.write(file, JSON.pretty_generate(json) + "\n")
end

def install_vite?
  options[:javascript] == "vite"
end
apply_template!
