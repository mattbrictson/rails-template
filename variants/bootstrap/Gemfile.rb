insert_into_file "Gemfile", after: /gem "bcrypt".*\n/ do
  <<-GEMS.strip_heredoc
    gem 'bootstrap', '~> 4.0.0'
    gem "bootstrap_form",
      git: "https://github.com/bootstrap-ruby/bootstrap_form.git",
      branch: "master"
  GEMS
end

insert_into_file "Gemfile", after: /gem "dotenv-rails".*\n/ do
  <<-GEMS.strip_heredoc
    gem "font-awesome-rails"
  GEMS
end
