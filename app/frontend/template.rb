empty_directory_with_keep_file "app/frontend/fonts"
empty_directory_with_keep_file "app/frontend/images"
empty_directory "app/frontend/stylesheets/mixins"

copy_file "app/assets/stylesheets/colors.scss", "app/frontend/stylesheets/colors.scss"
copy_file "app/assets/stylesheets/application.sass.scss", "app/frontend/stylesheets/index.scss"
copy_file "app/assets/stylesheets/mixins/typography.scss", "app/frontend/stylesheets/mixins/typography.scss"

gsub_file "app/frontend/stylesheets/index.scss", /@use "\./, '@use "~/stylesheets'

package_json = File.read("package.json")
if package_json.match?(%r{@hotwired/turbo-rails})
  prepend_to_file "app/frontend/entrypoints/application.js", <<~JS
    import "@hotwired/turbo-rails";
  JS
end
if package_json.match?(%r{@hotwired/stimulus})
  prepend_to_file "app/frontend/entrypoints/application.js", <<~JS
    import "~/controllers";
    import "~/stylesheets/index.scss";
  JS
end

# Remove sprockets
gsub_file "Gemfile", /^gem "sprockets.*\n/, ""
remove_file "config/initializers/assets.rb"
remove_dir "app/assets"
comment_lines "config/environments/development.rb", /^\s*config\.assets\./
comment_lines "config/environments/production.rb", /^\s*config\.assets\./
