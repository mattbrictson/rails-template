if install_vite?
  insert_into_file "config/application.rb", <<-RUBY, before: "  end"

    # Prevents Rails from trying to eager-load the contents of app/frontend
    config.javascript_path = "frontend"
  RUBY
end
