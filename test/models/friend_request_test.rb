require "test_helper"

class FriendRequestTest < ActiveSupport::TestCase
  test "is not valid without sender" do
    assert_not FriendRequest.new(receiver_id: users(:user_one).id, status: "Unanswered").valid?
  end

  test "is not valid without receiver" do
    assert_not FriendRequest.new(sender_id: users(:user_one).id, status: "Unanswered").valid?
  end

  test "is not valid without status" do
    assert_not FriendRequest.new(sender_id: users(:user_one).id,
                                 receiver_id: users(:user_two).id).valid?
  end

  test "automatically creates friend request notification" do
    user_one = users(:user_one)
    user_two = users(:user_two)
    friend_request = FriendRequest.create(sender_id: user_one.id, receiver_id: user_two.id, status: "Unanswered")
    assert_not_nil FriendRequestNotification.find_by(notifiable_id: friend_request.id)
  end
end
