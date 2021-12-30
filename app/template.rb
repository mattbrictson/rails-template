copy_file "app/controllers/home_controller.rb"
copy_file "app/controllers/concerns/basic_auth.rb"
copy_file "app/helpers/layout_helper.rb"

remove_dir "app/jobs"
empty_directory_with_keep_file "app/workers"

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

insert_into_file "app/views/layouts/base.html.erb", <<-ERB, before: %r{^\s*</head>}
    <%= yield(:head) %>
ERB

copy_file "app/views/layouts/application.html.erb"
copy_file "app/views/shared/_flash.html.erb"
copy_file "app/views/home/index.html.erb"
