copy_file "app/controllers/home_controller.rb"
copy_file "app/controllers/concerns/basic_auth.rb"
copy_file "app/helpers/layout_helper.rb"
copy_file "app/views/layouts/application.html.erb", force: true
template "app/views/layouts/base.html.erb.tt"
copy_file "app/views/shared/_flash.html.erb"
copy_file "app/views/home/index.html.erb"

remove_dir "app/jobs"
empty_directory_with_keep_file "app/workers"

insert_into_file "app/controllers/application_controller.rb", after: /^class ApplicationController.*\n/ do
  <<-RUBY
  include BasicAuth
  RUBY
end
