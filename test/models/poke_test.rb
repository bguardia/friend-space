require "test_helper"

class PokeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "can poke friends" do
    user_one = users(:friend_one)
    user_two = users(:friend_two)
    poke = Poke.new(sender_id: user_one.id, receiver_id: user_two.id)
    assert poke.valid?
  end

  test "cannot poke non-friends" do
    user_one = users(:user_one)
    user_two = users(:user_two)
    poke = Poke.new(sender_id: user_one.id, receiver_id: user_two.id)
    assert_not poke.valid?
  end

  test "creates poke notification on creation" do
    user_one = users(:friend_one)
    user_two = users(:friend_two)
    poke = Poke.create(sender_id: user_one.id, receiver_id: user_two.id)
    assert_not_nil PokeNotification.find_by(receiver_id: user_two.id)
  end
end
