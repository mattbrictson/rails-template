source_paths.unshift(File.dirname(__FILE__))

apply "Gemfile.rb"
apply "app/assets/stylesheets/application.scss.rb"
copy_file "app/assets/javascripts/bootstrap.js"
copy_file "app/assets/stylesheets/bootstrap.scss"
copy_file "app/helpers/navbar_helper.rb"
copy_file "app/views/layouts/application.html.erb", :force => true
template "app/views/shared/_footer.html.erb.tt"
template "app/views/shared/_navbar.html.erb.tt"
copy_file "app/views/shared/_page_header.erb"
copy_file "lib/templates/erb/controller/view.html.erb"
copy_file "lib/templates/erb/scaffold/_form.html.erb"
copy_file "lib/templates/erb/scaffold/edit.html.erb"
copy_file "lib/templates/erb/scaffold/index.html.erb"
copy_file "lib/templates/erb/scaffold/new.html.erb"
copy_file "lib/templates/erb/scaffold/show.html.erb"
copy_file "test/helpers/navbar_helper_test.rb"
