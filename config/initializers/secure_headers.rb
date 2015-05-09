# See https://github.com/twitter/secureheaders#configuration
::SecureHeaders::Configuration.configure do |config|
  config.hsts = { :max_age => 20.years.to_i, :include_subdomains => false }
  config.x_frame_options = { :value => "SAMEORIGIN" }
  config.x_xss_protection = { :value => 1, :mode => "block" }
  config.x_content_type_options = { :value => "nosniff" }
  config.x_download_options = false
  config.x_permitted_cross_domain_policies = { :value => "none" }
  config.csp = false
  config.hpkp = false
end
