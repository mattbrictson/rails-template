Rails.application.configure do
  config.active_job.queue_adapter = :sidekiq
end
