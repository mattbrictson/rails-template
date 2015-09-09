class ActiveSupport::TestCase
  setup { ActionMailer::Base.deliveries.clear }
end
