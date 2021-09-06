require "application_system_test_case"

class CommentNotificationsTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit comment_notifications_url
  #
  #   assert_selector "h1", text: "CommentNotifications"
  # end

  test "mark as read" do
    user = users(:user_one)
    post = posts(:one)
    commentor = users(:user_two)
    commentor_name = "#{commentor.profile.firstname} #{commentor.profile.lastname}"
    post.comments.create(user_id: commentor.id, body: "a comment")

    sign_in(user)
    visit notifications_path
    comment_notification = find('p', text: "#{commentor_name} commented on your post.").ancestor('.box')
    comment_notification.find('.fa-envelope-open-text').ancestor('button').click
    comment_notification = find('p', text: "#{commentor_name} commented on your post.").ancestor('.box')
    comment_notification.has_no_css?('has-background-info-light')
  end

  test "archiving request" do
    user = users(:user_one)
    post = posts(:one)
    commentor = users(:user_two)
    commentor_name = "#{commentor.profile.firstname} #{commentor.profile.lastname}"
    post.comments.create(user_id: commentor.id, body: "a comment")
    
    sign_in(user)
    visit notifications_path
    comment_notification = find('a', text: "your post").ancestor('.box')
    comment_notification.find('.fa-archive').ancestor('button').click
    assert_no_selector 'a', text: "your post"
  end

  test "visiting comment via notification" do
    user = users(:user_one)
    post = posts(:one)
    commentor = users(:user_two)
    post.comments.create(user_id: commentor.id, body: "a comment")

    sign_in(user)
    visit notifications_path
    find('a', text: "your post").click
    assert_selector 'div.content', text: "a comment" 
  end
end
