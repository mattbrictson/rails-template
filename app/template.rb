apply "app/assets/javascripts/application.js.rb"
copy_file "app/assets/stylesheets/application.css.scss"
remove_file "app/assets/stylesheets/application.css"

insert_into_file "app/controllers/application_controller.rb",
                 :after => /protect_from_forgery.*\n/ do
  "  ensure_security_headers\n"
end

copy_file "app/controllers/home_controller.rb"
copy_file "app/helpers/javascript_helper.rb"
copy_file "app/helpers/layout_helper.rb"
copy_file "app/helpers/retina_image_helper.rb"
copy_file "app/views/layouts/application.html.erb", :force => true
template "app/views/layouts/base.html.erb.tt"
copy_file "app/views/shared/_flash.html.erb"
copy_file "app/views/home/index.html.erb"
empty_directory_with_keep_file "app/jobs"
empty_directory_with_keep_file "app/workers"
