require "test_helper"

class PostFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "creating a post" do
    sign_in(users(:user_one))
    get "/"
    assert_response :success
    assert_difference('Post.count') do
      post "/posts", params: { post: { body: "A test post" }}
    end
    assert_response :redirect #redirect somewhere to show newly created post
    follow_redirect!
    assert_response :success

    assert_select "p", "A test post"
  end

  test "editing a post" do
    user = users(:user_one)
    post = posts(:one)
    sign_in(user)
    get edit_post_path(post)
    assert_response :success

    patch post_path(post), params: { post: { body: "A different post body"}}
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_select "p", "A different post body"
  end

  test "deleting a post" do
    sign_in(users(:user_one))
    post = posts(:one)

    assert_difference('Post.count', -1) do
      delete post_path(post)
    end
    
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_select "h1", "FriendSpace"
  end
end
