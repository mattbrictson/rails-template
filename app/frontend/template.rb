empty_directory_with_keep_file "app/frontend/fonts"
empty_directory_with_keep_file "app/frontend/images"

copy_file "app/frontend/stylesheets/index.css"
copy_file "app/frontend/stylesheets/base.css"
copy_file "app/frontend/stylesheets/reset.css"

copy_file "app/frontend/images/example.svg"
copy_file "app/lib/vite_inline_svg_file_loader.rb"
copy_file "app/helpers/inline_svg_helper.rb"
copy_file "test/helpers/inline_svg_helper_test.rb"

package_json = File.read("package.json")
if package_json.match?(%r{@hotwired/turbo-rails})
  prepend_to_file "app/frontend/entrypoints/application.js", <<~JS
    import "@hotwired/turbo-rails";
  JS
end
if package_json.match?(%r{@hotwired/stimulus})
  prepend_to_file "app/frontend/entrypoints/application.js", <<~JS
    import "~/controllers";
    import "~/stylesheets/index.css";
  JS
end

# Remove sprockets
gsub_file "Gemfile", /^gem "sprockets.*\n/, ""
remove_file "config/initializers/assets.rb"
remove_dir "app/assets"
comment_lines "config/environments/development.rb", /^\s*config\.assets\./
comment_lines "config/environments/production.rb", /^\s*config\.assets\./
