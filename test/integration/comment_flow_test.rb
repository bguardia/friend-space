require "test_helper"

class CommentFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "create a comment" do
    sign_in(users(:user_two))
    post = posts(:one)

    get post_path(post)
    assert_response :success

    get new_post_comment_path(post)
    assert_response :success

    assert_difference('Comment.count') do
      post post_comments_path(post), params: { comment: { body: "A post comment"}}
    end

    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_select "div.content", "A post comment"
  end

  test "edit a comment" do
    sign_in(users(:commentor))
    comment = comments(:one)

    get edit_comment_path(comment)
    assert_response :success

    patch comment_path(comment), params: { comment: { body: "Edited comment body"}}
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_select "div.content", "Edited comment body"
  end

  test "delete a comment" do
    sign_in(users(:commentor))
    comment = comments(:one)

    assert_difference('Comment.count', -1) do
      delete comment_path(comment)
    end

    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
