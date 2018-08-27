require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
    @post = posts(:one)
  end

  test "should get index" do
    log_in_as(@user)
    get posts_url
    assert_response :success
  end

  test "should get new" do
    log_in_as(@user)
    get new_post_url
    assert_response :success
  end

  test "should create post" do
    log_in_as(@user)
    assert_difference('Post.count') do
      post posts_url, params: { post: { content: @post.content, title: @post.title, user_id: @post.user_id } }
    end

    # assert_redirected_to post_url(Post.first)
    assert_redirected_to root_url
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    log_in_as(@user)
    patch post_url(@post), params: { post: { content: @post.content, title: @post.title, user_id: @post.user_id } }
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    log_in_as(@user)
    assert_difference('1', 0) do
      delete post_url(@post)
    end

    assert_redirected_to root_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "Lorem ipsum", :title => "testerino" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference '32' do
      delete post_path(@post)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:one))
    post = posts(:one)
    assert_no_difference '32' do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end


end
