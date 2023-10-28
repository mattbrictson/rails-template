# Copy controllers, helpers, and other files
copy_file "app/controllers/home_controller.rb"
copy_file "app/controllers/concerns/basic_auth.rb"
copy_file "app/helpers/layout_helper.rb"

# Insert include BasicAuth into application_controller.rb
insert_into_file "app/controllers/application_controller.rb", after: /^class ApplicationController.*\n/ do
  <<-RUBY
  include BasicAuth
  RUBY
end

# Rename application layout to base layout
File.rename "app/views/layouts/application.html.haml", "app/views/layouts/base.html.haml"

# Prepend comment to base layout
prepend_to_file "app/views/layouts/base.html.haml", <<~HAML
  -# The "base" layout contains boilerplate common to *all* views.
HAML

# Add 'lang' attribute to the html tag
gsub_file "app/views/layouts/base.html.haml", "%html", "%html(lang=\"en\")"

# Insert meta information and yield(:head) into base layout
insert_into_file "app/views/layouts/base.html.haml", <<~HAML, after: "%head"
  <!-- #{app_const_base.titleize} #{Rails.application.config.version} (#{l(Rails.application.config.version_time)}) -->
  = capybara_lockstep if defined?(Capybara::Lockstep)
HAML

# Replace title tag with HAML code
gsub_file "app/views/layouts/base.html.haml", "%title", <<~HAML
  %title
    - if content_for?(:title)
      = strip_tags(yield(:title)) + " – "
    = app_const_base.titleize
  / Specifies the default name of home screen bookmark in iOS
  %meta{name: "apple-mobile-web-app-title", content: app_const_base.titleize}
HAML

# Yield head content
insert_into_file "app/views/layouts/base.html.haml", <<~HAML.rstrip, before: /\s*\%\/head/
  = yield(:head)
HAML

# Update stylesheet_link_tag and javascript_pack_tag if Vite is installed
if install_vite?
  gsub_file "app/views/layouts/base.html.haml", /^.*= stylesheet_link_tag.*/, ""
  gsub_file "app/views/layouts/base.html.haml",
            "= javascript_pack_tag 'application'",
            '= javascript_pack_tag "application", "data-turbo-track" => "reload"'
end

# Copy HAML templates
copy_file "app/views/layouts/application.html.haml"
copy_file "app/views/shared/_flash.html.haml"
template "app/views/home/index.html.haml.tt"
