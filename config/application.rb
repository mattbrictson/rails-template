gsub_file "config/application.rb",
          "# config.time_zone = 'Central Time (US & Canada)'",
          'config.time_zone = "Pacific Time (US & Canada)"'

insert_into_file "config/application.rb", :before => /^  end/ do
  <<-'RUBY'

    # Ensure non-standard paths are eager-loaded
    config.eager_load_paths += ["#{config.root}/app/workers"]
  RUBY
end
