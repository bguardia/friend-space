require "test_helper"

class CommentNotificationTest < ActiveSupport::TestCase
  include NotificationTester
  
  def before_setup
    super
    @notification = CommentNotification.new
    @notifiable = comments(:one)
  end
  # test "the truth" do
  #   assert true
  # end
end
