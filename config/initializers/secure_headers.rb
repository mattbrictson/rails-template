# See https://github.com/twitter/secureheaders#configuration
::SecureHeaders::Configuration.default do |config|
  config.hsts = "max-age=#{20.years.to_i}"
  config.x_frame_options = "SAMEORIGIN"
  config.x_xss_protection = "1; mode=block"
  config.x_content_type_options = "nosniff"
  config.x_download_options = false
  config.x_permitted_cross_domain_policies = "none"
  config.csp = false
  config.hpkp = false
end
