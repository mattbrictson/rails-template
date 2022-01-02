copy_file "app/controllers/home_controller.rb"
copy_file "app/controllers/concerns/basic_auth.rb"
copy_file "app/helpers/layout_helper.rb"

insert_into_file "app/controllers/application_controller.rb", after: /^class ApplicationController.*\n/ do
  <<-RUBY
  include BasicAuth
  RUBY
end

File.rename "app/views/layouts/application.html.erb", "app/views/layouts/base.html.erb"

prepend_to_file "app/views/layouts/base.html.erb", <<~ERB
<%# The "base" layout contains boilerplate common to *all* views. %>

ERB

insert_into_file "app/views/layouts/base.html.erb", <<-ERB, after: "<head>"

    <!-- #{app_const_base.titleize} <%= Rails.application.config.version %> (<%= l(Rails.application.config.version_time) %>) -->

ERB

gsub_file "app/views/layouts/base.html.erb", %r{^\s*<title>.*</title>}, <<-ERB
    <title>
      <%= strip_tags(yield(:title)) + " – " if content_for?(:title) %>
      #{app_const_base.titleize}
    </title>
    <%# Specifies the default name of home screen bookmark in iOS %>
    <meta name="apple-mobile-web-app-title" content="#{app_const_base.titleize}">
ERB

insert_into_file "app/views/layouts/base.html.erb", <<-ERB.rstrip, before: %r{^\s*</head>}
    <%= yield(:head) %>
ERB

if install_vite?
  gsub_file "app/views/layouts/base.html.erb", /^.*<%= stylesheet_link_tag.*$/, ""
  gsub_file "app/views/layouts/base.html.erb",
            /vite_javascript_tag 'application' %>/,
            'vite_javascript_tag "application", "data-turbo-track": "reload" %>'
  insert_into_file "app/views/layouts/base.html.erb", <<-ERB, before: /^.*<%= vite_javascript_tag/
    <%= vite_stylesheet_tag "application.scss", "data-turbo-track": "reload" %>
  ERB
end

copy_file "app/views/layouts/application.html.erb"
copy_file "app/views/shared/_flash.html.erb"
copy_file "app/views/home/index.html.erb"
