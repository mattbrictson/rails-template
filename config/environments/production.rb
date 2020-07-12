uncomment_lines "config/environments/production.rb", /config\.force_ssl = true/
gsub_file "config/environments/production.rb",
          "config.force_ssl = true",
          'config.force_ssl = ENV["RAILS_FORCE_SSL"].present?'

insert_into_file "config/environments/production.rb", after: /# config\.action_mailer\.raise_deliv.*\n/ do
  <<-RUBY

  # Production email config
  config.action_mailer.delivery_method = :postmark
  config.action_mailer.postmark_settings = { api_token: ENV["POSTMARK_API_KEY"] }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {
    host: "#{production_hostname}",
    protocol: "https"
  }
  config.action_mailer.asset_host = "https://#{production_hostname}"
  RUBY
end
