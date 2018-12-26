if apply_capistrano?
  prepend_to_file "config.ru" do
    <<-'RUBY'
if defined?(Unicorn)
  require "unicorn/worker_killer"
  use Unicorn::WorkerKiller::MaxRequests, 3072, 4096
end

    RUBY
  end
end

insert_into_file "config.ru", before: /^run Rails.application/ do
  <<-RUBY
use Rack::CanonicalHost, ENV["HOSTNAME"] if ENV["HOSTNAME"].present?
  RUBY
end
