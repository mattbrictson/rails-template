gsub_file "config/application.rb",
          "# config.time_zone = 'Central Time (US & Canada)'",
          'config.time_zone = "Pacific Time (US & Canada)"'

if install_vite?
  insert_into_file "config/application.rb", <<-RUBY, before: "  end"

    # Prevents Rails from trying to eager-load the contents of app/frontend
    config.javascript_path = "frontend"
  RUBY
end
