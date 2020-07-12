require "sidekiq/web"

Sidekiq::Web.app_url = "/"

unless Rails.env.development?
  sidekiq_username = ENV["SIDEKIQ_WEB_USERNAME"]
  sidekiq_password = ENV["SIDEKIQ_WEB_PASSWORD"]

  Sidekiq::Web.use(Rack::Auth::Basic, "Application") do |username, password|
    if sidekiq_username.present? && sidekiq_password.present?
      ActiveSupport::SecurityUtils.secure_compare(username, sidekiq_username) &
        ActiveSupport::SecurityUtils.secure_compare(password, sidekiq_password)
    end
  end
end
