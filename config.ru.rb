prepend_to_file "config.ru" do
  <<-'RUBY'
if defined?(Unicorn)
  require "unicorn/worker_killer"
  use Unicorn::WorkerKiller::MaxRequests, 3072, 4096
end

  RUBY
end

