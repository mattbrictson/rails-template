gsub_file "config/application.rb",
          "# config.time_zone = 'Central Time (US & Canada)'",
          'config.time_zone = "Pacific Time (US & Canada)"'

insert_into_file "config/application.rb", :before => /^  end/ do
  <<-'RUBY'

    # Bootscale needs this to prevent stale cache
    initializer :regenerate_require_cache, :before => :load_environment_config do
      Bootscale.regenerate
    end

    # Ensure non-standard paths are eager-loaded in production
    # (these paths are also autoloaded in development mode)
    # config.eager_load_paths += %W(#{config.root}/lib)
  RUBY
end
