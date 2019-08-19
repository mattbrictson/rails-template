insert_into_file "config.ru", before: /^run Rails.application/ do
  <<-RUBY
use Rack::CanonicalHost, ENV["HOSTNAME"] if ENV["HOSTNAME"].present?
  RUBY
end
