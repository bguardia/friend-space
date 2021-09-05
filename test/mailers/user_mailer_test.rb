require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "send welcome mail" do
    user = users(:user_one)
    email = UserMailer.with(user: user).welcome_email

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["from@friendspace.com"], email.from
    assert_equal [user.email], email.to
    assert_equal "Welcome to FriendSpace!", email.subject

  end
end
