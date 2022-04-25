module BasicAuth
  extend ActiveSupport::Concern

  included do
    before_action :require_basic_auth
  end

  private

  def require_basic_auth
    expected_username = ENV.fetch("BASIC_AUTH_USERNAME", nil)
    expected_password = ENV.fetch("BASIC_AUTH_PASSWORD", nil)
    return true if expected_username.blank? || expected_password.blank?

    authenticate_or_request_with_http_basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(username, expected_username) & \
        ActiveSupport::SecurityUtils.secure_compare(password, expected_password)
    end
  end
end
