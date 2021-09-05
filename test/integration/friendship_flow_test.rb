require "test_helper"

class FriendshipFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "sending a friend request" do
    user_one = users(:user_one)
    user_two = users(:user_two)

    #Create friend request
    sign_in(user_one)

    get user_path(user_two)
    assert_response :success

    assert_difference('FriendRequest.count') do
      post friend_requests_path, params: { friend_request: { receiver_id: user_two.id }}
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success 

    #Check friend requests page for sent request
    get friend_requests_path
    assert_response :success

    #Assure the receiving user's name appears on the request
    assert_select "a p", "#{user_two.profile.firstname} #{user_two.profile.lastname}"

  end

  test "receiving a friend request" do
    sender = users(:user_one)
    receiver = users(:user_two)

    assert_difference('FriendRequest.count') do
      FriendRequest.create(sender_id: sender.id, receiver_id: receiver.id, status: "Unanswered")
    end

    sign_in(receiver)

    get notifications_path
    assert_response :success

    assert_select "div.media-content div.content p", "#{sender.profile.firstname} #{sender.profile.lastname} has sent you a friend request."
  end

  test "accepting a friend request" do
    sender = users(:user_one)
    receiver = users(:user_two)
    friend_request = FriendRequest.new(sender_id: sender.id, receiver_id: receiver.id, status: "Unanswered")

    assert_difference('FriendRequest.count') do
      friend_request.save
    end

    sign_in(receiver)

    assert_changes('FriendRequest.find_by(id: friend_request.id).status') do
      patch friend_request_path(friend_request), 
      params: { friend_request: { status: "Accepted"}}, 
      headers: { referer: notifications_url } #redirect back to notifications_url to check change in friend request status
    end

    #Redirect to previous page (in this case notifications)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    
    #Show update to friend request status
    assert_select "div.media-content div.content p", "You accepted #{sender.profile.firstname} #{sender.profile.lastname}'s friend request."

    #Accepting friend request creates new friendship
    assert_not_nil Friendship.find_by(user_id: sender.id, friend_id: receiver.id)
  end
  
end
