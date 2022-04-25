insert_into_file "config.ru", before: /^run Rails.application/ do
  <<-RUBY
use Rack::CanonicalHost, ENV.fetch("RAILS_HOSTNAME", nil) if ENV["RAILS_HOSTNAME"].present?
  RUBY
end
