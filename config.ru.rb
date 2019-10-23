insert_into_file "config.ru", before: /^run Rails.application/ do
  <<-RUBY
use Rack::CanonicalHost, ENV["RAILS_HOSTNAME"] if ENV["RAILS_HOSTNAME"].present?
  RUBY
end
