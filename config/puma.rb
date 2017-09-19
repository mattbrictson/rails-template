threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port ENV.fetch("PORT", 3000)
environment ENV.fetch("RAILS_ENV") { "development" }

workers_count = ENV.fetch("WEB_CONCURRENCY") { 1 }.to_i

if workers_count > 1
  workers workers_count

  preload_app!

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end

  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
