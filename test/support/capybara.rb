# Capybara + poltergeist allow JS testing via headless webkit
require "capybara/rails"
require "capybara/poltergeist"
Capybara.javascript_driver = :poltergeist

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # This comes from the minitest-capybara gem
  include Capybara::Assertions

  # Ensure each test gets a clean session
  setup { Capybara.current_session.driver.browser.clear_cookies }
end

# Monkey patch so that AR shares a single DB connection among all threads.
# This ensures data consistency between the test thread and poltergeist thread.
# rubocop:disable Style/ClassVars
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || begin
      ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
    end
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
