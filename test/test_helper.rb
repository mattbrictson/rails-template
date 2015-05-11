ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

# Mocha provides mocking and stubbing helpers
require "mocha/mini_test"

# Minitest::Reporters adds color and progress bar to the test runner
require "minitest/reporters"
Minitest::Reporters.use!(
  Minitest::Reporters::ProgressReporter.new,
  ENV,
  Minitest.backtrace_filter)

# Capybara + poltergeist allow JS testing via headless webkit
require "capybara/rails"
require "capybara/poltergeist"
Capybara.javascript_driver = :poltergeist

# Use Sidekiq's test fake that pushes all jobs into a jobs array
require "sidekiq/testing"
Sidekiq::Testing.fake!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  setup { ActionMailer::Base.deliveries.clear }
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end

# Monkey patch so that AR shares a single DB connection among all threads.
# This ensures data consistency between the test thread and poltergeist thread.
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
