uncomment_lines "config/environments/production.rb", /config\.force_ssl = true/
uncomment_lines "config/environments/production.rb", /config\.active_job/
uncomment_lines "config/environments/production.rb", /raise_delivery_errors =/
gsub_file "config/environments/production.rb", ":resque", ":sidekiq"
gsub_file "config/environments/production.rb", " (and separate queues per environment)", ""
gsub_file "config/environments/production.rb",
          /queue_name_prefix = .*$/,
          "queue_name_prefix = nil # Not supported by sidekiq"
gsub_file "config/environments/production.rb", /raise_delivery_errors = false/, "raise_delivery_errors = true"
gsub_file "config/environments/production.rb", /\bSTDOUT\b/, "$stdout"
gsub_file "config/environments/production.rb",
          "config.force_ssl = true",
          'config.force_ssl = ENV["RAILS_DISABLE_SSL"].blank?'

insert_into_file "config/environments/production.rb", after: /config\.action_mailer\.raise_deliv.*\n/ do
  <<-RUBY

  # Production email config
  config.action_mailer.delivery_method = :postmark
  config.action_mailer.postmark_settings = {
    api_token: ENV.fetch("POSTMARK_API_KEY", nil)
  }
  config.action_mailer.default_url_options = {
    host: "#{production_hostname}",
    protocol: "https"
  }
  config.action_mailer.asset_host = "https://#{production_hostname}"
  RUBY
end
