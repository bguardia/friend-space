require "test_helper"

class UserSignUpTest < ActionDispatch::IntegrationTest
  test "start at login page" do
    get "/"
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "sign up new user" do
    get new_user_registration_path
    assert_response :success

    assert_difference('User.count') do
      post user_registration_path, params: { user: { email: "int_test@test.jmail.com", password: "1234567", password_confirmation: "1234567"} }
    end
    assert_response :redirect #Redirect to new profile page after sign-up
    follow_redirect!
    assert_response :success

    assert_select "h2", "Edit your Profile"
  end

end
