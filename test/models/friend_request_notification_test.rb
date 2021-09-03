require "test_helper"

class FriendRequestNotificationTest < ActiveSupport::TestCase
  include NotificationTester

  def before_setup
    super
    @notification = FriendRequestNotification.new
    @notifiable = FriendRequest.new(sender_id: users(:user_one),
                                    receiver_id: users(:user_two))
  end
  # test "the truth" do
  #   assert true
  # end
end
