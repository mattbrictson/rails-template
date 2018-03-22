prepend_to_file "app/assets/stylesheets/application.scss" do
  <<-SCSS.strip_heredoc

    // Custom bootstrap variables must be set or imported *before* bootstrap.
    @import "bootstrap";
    @import "rails_bootstrap_forms";
    @import "font-awesome";

    body {
    padding-top: 5rem;
    }
    .page-header {
    padding: 3rem 0 0.5rem;
    }
    .starter-template {
    text-align: center;
    }
  SCSS
end
