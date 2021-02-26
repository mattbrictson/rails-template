require "bundler"
require "json"
RAILS_REQUIREMENT = "~> 6.1.0".freeze

def apply_template!
  assert_minimum_rails_version
  assert_valid_options
  assert_postgresql
  add_template_repository_to_source_path
  class_option :production_domain, type: :string, default: 'example2.com'

  # We're going to handle bundler and webpacker ourselves.
  # Setting these options will prevent Rails from running them unnecessarily.
  self.options = options.merge(
    skip_bundle: true,
    skip_webpack_install: true
  )

  template "Gemfile.tt", force: true

  template "README.md.tt", force: true
  remove_file "README.rdoc"

  template "example.env.tt"
  copy_file "editorconfig", ".editorconfig"
  copy_file "gitignore", ".gitignore", force: true
  copy_file "overcommit.yml", ".overcommit.yml"
  template "ruby-version.tt", ".ruby-version", force: true

  copy_file "Guardfile"
  copy_file "Procfile"
  copy_file "Procfile.dev"

  apply "Rakefile.rb"
  apply "config.ru.rb"
  apply "app/template.rb"
  apply "bin/template.rb"
  apply "circleci/template.rb"
  apply "config/template.rb"
  apply "lib/template.rb"
  apply "test/template.rb"

  git :init unless preexisting_git_repo?
  empty_directory ".git/safe"

  run_with_clean_bundler_env "bundle update"
  run_with_clean_bundler_env "bin/rails webpacker:install"
  install_dart_sass unless sprockets?
  create_database_and_initial_migration
  run_with_clean_bundler_env "bin/setup"

  binstubs = %w[brakeman bundler bundler-audit guard rubocop sidekiq terminal-notifier]
  run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')} --force"

  template "rubocop.yml.tt", ".rubocop.yml"
  run_rubocop_autocorrections

  template "eslintrc.js", ".eslintrc.js"
  template "prettierrc.js", ".prettierrc.js"
  template "stylelintrc.js", ".stylelintrc.js"
  add_yarn_lint_and_run_fix
  add_foreman_start_script

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
  @production_hostname ||= production_domain
end

def gemfile_requirement(name)
  @original_gemfile ||= IO.read("Gemfile")
  req = @original_gemfile[/gem\s+['"]#{name}['"]\s*(,[><~= \t\d\.\w'"]*)?.*$/, 1]
  req && req.gsub("'", %(")).strip.sub(/^,\s*"/, ', "')
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
              if Bundler.respond_to?(:with_unbundled_env)
                Bundler.with_unbundled_env { run(cmd) }
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
end

def create_database_and_initial_migration
  return if Dir["db/migrate/**/*.rb"].any?
  run_with_clean_bundler_env "bin/rails db:create"
  run_with_clean_bundler_env "bin/rails generate migration initial_migration"
end

def add_foreman_start_script
  run_with_clean_bundler_env "yarn add --dev foreman"
  add_package_json_script(start: "nf start -p 3000 -j Procfile.dev")
end

def add_yarn_lint_and_run_fix
  packages = %w[
    babel-eslint
    eslint
    eslint-config-prettier
    eslint-plugin-prettier prettier
    npm-run-all
    stylelint
    stylelint-config-recommended-scss
    stylelint-config-standard
    stylelint-declaration-use-variable
    stylelint-scss
  ]
  run_with_clean_bundler_env "yarn add #{packages.join(' ')} -D"
  add_package_json_script("lint": "npm-run-all -c lint:*")
  add_package_json_script("lint:js": "eslint 'app/{assets,components,javascript}/**/*.{js,jsx}'")
  add_package_json_script("lint:css": "stylelint 'app/{assets,components,javascript}/**/*.{css,scss}'")
  run_with_clean_bundler_env "yarn lint:js --fix"
  run_with_clean_bundler_env "yarn lint:css --fix"
end

def add_package_json_script(scripts)
  package_json = JSON.parse(IO.read("package.json"))
  package_json["scripts"] ||= {}
  scripts.each do |name, script|
    package_json["scripts"][name.to_s] = script
  end
  package_json = {
    "name" => package_json["name"],
    "scripts" => package_json["scripts"].sort.to_h
  }.merge(package_json)
  IO.write("package.json", JSON.pretty_generate(package_json) + "\n")
end

def install_dart_sass
  run_with_clean_bundler_env "yarn add -D sass" unless sprockets?
  insert_into_file "config/webpack/environment.js", <<~JAVASCRIPT, before: /^module\.exports/
    const sassLoader = environment.loaders
      .get("sass")
      .use.find((el) => el.loader === "sass-loader");
    sassLoader.options.implementation = require("sass");

  JAVASCRIPT
end

def sprockets?
  ! options[:skip_sprockets]
end

apply_template!
