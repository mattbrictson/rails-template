require "sidekiq/web"

sidekiq_username = ENV.fetch("SIDEKIQ_WEB_USERNAME")
sidekiq_password = ENV.fetch("SIDEKIQ_WEB_PASSWORD")

Sidekiq::Web.app_url = "/"
Sidekiq::Web.use(Rack::Auth::Basic, "Application") do |username, password|
  username == sidekiq_username &&
    ActiveSupport::SecurityUtils.secure_compare(password, sidekiq_password)
end
