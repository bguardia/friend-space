require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "can access profile" do
    user = users(:user_one)
    assert user.profile
  end

  test "can access friends" do
    user = users(:friend_one)
    friend = users(:friend_two)
    assert user.friends.exists?(friend.id)
  end

  test "can access posts" do
    user = users(:user_one)
    user.posts.create(body: "my new post")
    assert_not_empty user.posts
  end

  test "can access comments" do
    commentor = users(:commentor)
    assert_not_empty commentor.comments
  end
end
