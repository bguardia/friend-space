require "test_helper"

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "not valid without body" do
    user = users(:user_two)
    post =  posts(:one)
    comment = user.comments.build(post_id: post.id)

    assert_not comment.valid?
  end

  test "not valid without post_id" do
    user = users(:user_two)
    comment = user.comments.build(body: "no parent post!")

    assert_not comment.valid?
  end

  test "after creation creates comment notification" do
    commentor = users(:user_two)
    post = posts(:one)
    comment = commentor.comments.build(post_id: post.id, body: "Nice post!")
    comment.save

    assert_not_nil CommentNotification.find_by(notifiable_id: comment.id, notifiable_type: "Comment")
  end
end
