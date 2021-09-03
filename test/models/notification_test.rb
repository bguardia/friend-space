require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  include NotificationTester

  def before_setup
    super
    @notification = Notification.new
  end
  
  # test "the truth" do
  #   assert true
  # end
end
