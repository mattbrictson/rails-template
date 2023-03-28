empty_directory_with_keep_file "app/frontend/fonts"
empty_directory_with_keep_file "app/frontend/images"

copy_file "app/frontend/stylesheets/index.scss"

copy_file "app/helpers/vite_inline_svg_helper.rb"
copy_file "test/helpers/vite_inline_svg_helper_test.rb"

package_json = File.read("package.json")
if package_json.match?(%r{@hotwired/turbo-rails})
  prepend_to_file "app/frontend/entrypoints/application.js", <<~JS
    import "@hotwired/turbo-rails";
  JS
end
if package_json.match?(%r{@hotwired/stimulus})
  prepend_to_file "app/frontend/entrypoints/application.js", <<~JS
    import "~/controllers";
    import "~/stylesheets/main.scss";
  JS
end

# Remove sprockets
gsub_file "Gemfile", /^gem "sprockets.*\n/, ""
remove_file "config/initializers/assets.rb"
remove_dir "app/assets"
comment_lines "config/environments/development.rb", /^\s*config\.assets\./
comment_lines "config/environments/production.rb", /^\s*config\.assets\./
