mailer_regex = /config\.action_mailer\.raise_delivery_errors = false\n/

comment_lines "config/environments/development.rb", mailer_regex
insert_into_file "config/environments/development.rb", :after => mailer_regex do
  <<-RUBY

  # Ensure mailer works in development.
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  config.action_mailer.asset_host = "http://localhost:3000"
  RUBY
end

insert_into_file "config/environments/development.rb", :before => /^end/ do
  <<-RUBY

  # Limit log file size to 20MB with one backup
  log_file = open(config.paths["log"].first, "a")
  log_file.binmode
  config.logger = Logger.new(log_file, 1, 20971520)

  # Automatically inject JavaScript needed for LiveReload.
  config.middleware.insert_after(ActionDispatch::Static, Rack::LiveReload)
  RUBY
end
