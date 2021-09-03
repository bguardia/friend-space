require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  def setup
    super
    log_in(users(:user_one))
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1"
  end

  test "create a post" do
    visit posts_url
    fill_in "post[body]", with: "Creating a post"
    click_on "Share"
    assert_selector "p", text: "Creating a post"
  end

  test "visit post edit page" do
    post = posts(:one)
    visit post_path(post)
    click_link href: edit_post_path(post)
    assert_selector "label", text: "Edit Post"
  end

  test "edit a post" do
    post = posts(:one)
    visit edit_post_path(post)
    fill_in "post[body]", with: "Editing a post"
    click_on "Save Post"
    assert_selector "p", text: "Editing a post"
  end

  test "delete a post" do
    post = posts(:one)
    visit post_path(post)
    click_link href: post_path(post)
    assert_not Post.find_by(id: post.id)
  end

  test "no edit link shown for non-authors" do
    sign_out(users(:user_one))
    sign_in(users(:user_two))
    post = posts(:one)
    visit post_path(post)
    has_no_link? href: edit_post_path(post)
  end

  test "no delete link shown for non-authors" do
    sign_out(users(:user_one))
    sign_in(users(:user_two))
    post = posts(:one)
    visit post_path(post)
    has_no_link? href: post_path(post) #this relies on post not having another link to itself
  end
end
