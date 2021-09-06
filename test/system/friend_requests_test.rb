require "application_system_test_case"

class FriendRequestsTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit friend_requests_url
  #
  #   assert_selector "h1", text: "FriendRequests"
  # end

  test "sending a friend request" do
    user = users(:user_one)
    user_two = users(:user_two)
    user_two_name = "#{user_two.profile.firstname} #{user_two.profile.lastname}"
    sign_in(user)
    visit root_path
    click_link href: users_path
    user_box = find('p', text: user_two_name).ancestor('.box')
    user_box.click_on "Send Friend Request"
    assert_selector "p", text: "You have sent #{user_two_name} a friend request"
  end

  test "accepting a friend request" do
    user = users(:user_one)
    user_two = users(:user_two)
    user_two_name = "#{user_two.profile.firstname} #{user_two.profile.lastname}"
    FriendRequest.create(sender_id: user_two.id, receiver_id: user.id, status: "Unanswered")

    sign_in(user)
    visit notifications_path
    friend_request_box = find('a', text: user_two_name).ancestor('.box')
    friend_request_box.click_on "Accept"
    assert_selector "p", text: "You accepted #{user_two_name}'s friend request."
  end

  test "marking as read" do
    user = users(:user_one)
    user_two = users(:user_two)
    user_two_name = "#{user_two.profile.firstname} #{user_two.profile.lastname}"
    friend_request = FriendRequest.create(sender_id: user_two.id, receiver_id: user.id, status: "Unanswered")
    notification = FriendRequestNotification.find_by(notifiable_id: friend_request.id, notifiable_type: "FriendRequest")
    sign_in(user)
    visit notifications_path
    friend_request_box = find('a', text: user_two_name).ancestor('.box')
    friend_request_box.find('.fa-envelope-open-text').ancestor('button').click
    friend_request_box = find('a', text: user_two_name).ancestor('.box')
    friend_request_box.has_no_css?('.has-background-info-light')
  end

  test "archiving request" do
    user = users(:user_one)
    user_two = users(:user_two)
    user_two_name = "#{user_two.profile.firstname} #{user_two.profile.lastname}"
    friend_request = FriendRequest.create(sender_id: user_two.id, receiver_id: user.id, status: "Unanswered")
    notification = FriendRequestNotification.find_by(notifiable_id: friend_request.id, notifiable_type: "FriendRequest")
    sign_in(user)
    visit notifications_path
    friend_request_box = find('a', text: user_two_name).ancestor('.box')
    friend_request_box.find('.fa-archive').ancestor('button').click
    assert_no_selector 'a', text: user_two_name
   
  end
end
