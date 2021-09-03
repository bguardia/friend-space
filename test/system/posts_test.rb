require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase

  test "visiting the index" do
    log_in(users(:user_one))
    visit posts_url
    assert_selector "h1"
  end

  test "create a post" do
    log_in(users(:user_one))
    visit posts_url
    fill_in "post[body]", with: "Creating a post"
    click_on "Share"
    assert_selector "p", text: "Creating a post"
  end

  test "edit a post" do
    user = users(:user_one)
    log_in(user)
    post = posts(:one)
    puts "post.user: #{post.user}, user.profile: #{user.profile}"
    visit post_path(post)
    click_on "posts/#{post.id}/edit"
    assert_selector "label", text: "Edit Post"
  end
end
