module BasicAuth
  extend ActiveSupport::Concern

  included do
    before_action :require_basic_auth
  end

  private

  def require_basic_auth
    return true if ENV["BASIC_AUTH_USERNAME"].blank?
    return true if ENV["BASIC_AUTH_PASSWORD"].blank?

    authenticate_or_request_with_http_basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(username, ENV["BASIC_AUTH_USERNAME"]) & \
        ActiveSupport::SecurityUtils.secure_compare(password, ENV["BASIC_AUTH_PASSWORD"])
    end
  end
end
