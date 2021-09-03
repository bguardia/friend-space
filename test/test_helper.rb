ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

  def log_in(user)
    sign_in(user)
  end
end

module NotificationTester

  def define_vars
    @notification ||= Notification.new
    @notifiable ||= posts(:one) #Model required, type not important
  end

  def test_not_valid_without_receiver
    define_vars
    @notification.notifiable = @notifiable
    assert_not @notification.valid?
  end

  def test_not_valid_without_notifiable
    define_vars
    @notification.receiver = users(:user_one)
    assert_not @notification.valid?
  end

  def test_has_default_status
    define_vars
    @notification.receiver = users(:user_one)
    @notification.notifiable = @notifiable
    @notification.save
    assert_not_nil @notification.status
  end

  def test_only_accepts_valid_statuses
    define_vars
    @notification.receiver = users(:user_one)
    @notification.notifiable = @notifiable
    @notification.status = "Not a Valid Status"
    assert_not @notification.valid?
  end

  def test_notification_creation
    define_vars
    @notification.receiver = users(:user_one)
    @notification.notifiable = @notifiable
    assert @notification.save
  end
end
