require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "is not valid without body" do
    user = users(:user_one)
    assert_not Post.new(user_id: user.id).valid?
  end

  test "is valid with body" do
    user = users(:user_one)
    assert Post.new(user_id: user.id, body: "some text").valid?
  end

  test "is valid without body if photo attached" do
    user = users(:user_one)
    post = Post.new(user_id: user.id)
    post.image.attach(io: File.open("test/fixtures/files/grape.jpg"),
                      filename: "grape.jpg", 
                      content_type: "image/jpg")
    assert post.valid?
  end
end
