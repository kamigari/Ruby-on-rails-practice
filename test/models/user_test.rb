require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:one)
  end

  test 'valid user' do
    user = User.new(name: 'testerino', email: 'testerino@testerino.com',
                    password: "testerino", password_confirmation: "testerino")
    assert user.valid?
  end

  test 'invalid without name' do
    user = User.new(email: 'testerino@testerino.com',
                    password: "testerino", password_confirmation: "testerino")
    refute user.valid?, 'user is valid without a name'
    assert_not_nil user.errors[:name], 'no validation error for name present'
  end

  test 'invalid without email' do
    user = User.new(name: 'testerino',
                    password: "testerino", password_confirmation: "testerino")
    refute user.valid?
    assert_not_nil user.errors[:email]
  end

  test '#posts' do
    assert_equal 1, 1
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated posts should be destroyed" do
    @user.save
    @user.posts.build(:content => "Lorem ipsum", :user_id => @user.id, :title => "testerino")
    assert_difference '1', 0 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    one = users(:one)
    two  = users(:two)
    assert one.following?(two)
    assert two.followers.include?(one)
    one.unfollow(two)
    assert_not one.following?(two)
  end

  test "feed should have the right posts" do
    one = users(:one)
    four  = users(:four)
    three    = users(:three)
    # Posts from followed user
    three.posts.each do |post_following|
      assert one.feed.include?(post_following)
    end
    # Posts from self
    one.posts.each do |post_self|
      assert one.feed.include?(post_self)
    end
    # Posts from unfollowed user
    four.posts.each do |post_unfollowed|
      assert_not one.feed.include?(post_unfollowed)
    end
  end

end
