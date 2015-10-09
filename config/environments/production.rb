comment_lines "config/environments/production.rb",
              /config\.assets\.js_compressor = :uglifier/

insert_into_file "config/environments/production.rb",
                 :after => /# config\.assets\.css_compressor = :sass\n/ do
  <<-RUBY

  # Disable minification since it adds a *huge* amount of time to precompile.
  # Anyway, gzip alone gets us about 70% of the benefits of minify+gzip.
  config.assets.js_compressor = false
  config.assets.css_compressor = false
  RUBY
end

uncomment_lines "config/environments/production.rb",
                /config\.action_dispatch\.x_sendfile_header = 'X-Accel-Redirect' # for NGINX/i
uncomment_lines "config/environments/production.rb", /config\.force_ssl = true/

insert_into_file "config/environments/production.rb",
                 :after => /# config\.action_mailer\.raise_deliv.*\n/ do
  <<-RUBY

  # Production Mandrill SMTP config
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => "smtp.mandrillapp.com",
    :port => 587,
    :enable_starttls_auto => true,
    :user_name => ENV.fetch("MANDRILL_USERNAME"),
    :password => ENV.fetch("MANDRILL_API_KEY"),
    :authentication => "login",
    :domain => "#{production_hostname}"
  }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {
    host: "#{production_hostname}",
    protocol: "https"
  }
  config.action_mailer.asset_host = "https://#{production_hostname}"
  RUBY
end
