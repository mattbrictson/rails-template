prepend_to_file "app/assets/stylesheets/application.scss" do
  <<-SCSS.strip_heredoc
    //= require ./bootstrap
    //= require rails_bootstrap_forms
    //= require font-awesome
  SCSS
end
