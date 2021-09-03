require "test_helper"

class PokeNotificationTest < ActiveSupport::TestCase
  include NotificationTester

  def before_setup
    super
    @notification = PokeNotification.new
    @notifiable = Poke.new(sender_id: users(:user_one).id,
                           receiver_id: users(:user_two).id)
  end
  # test "the truth" do
  #   assert true
  # end
end
