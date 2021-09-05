require "test_helper"

class FriendshipTest < ActiveSupport::TestCase
  test "can create friendships between two users" do
     assert Friendship.create(user_id: users(:user_one).id, friend_id: users(:user_two))
  end

  test "cannot create friendship with oneself" do
    user_id = users(:user_one).id
    friendship = Friendship.new(user_id: user_id, friend_id: user_id)
    assert_not friendship.valid?
  end

  test "creates opposing friendship automatically" do
    user = users(:user_one)
    friend = users(:user_two)
    Friendship.create(user_id: user.id, friend_id: friend.id)
    assert_not_nil Friendship.find_by(user_id: friend.id, friend_id: user.id)
  end

  test "deletes opposing friendship automatically" do
    user = users(:friend_one)
    friend = users(:friend_two)
    Friendship.find_by(user_id: user.id, friend_id: friend.id).destroy
    assert_nil Friendship.find_by(user_id: friend.id, friend_id: user.id)
  end
end
