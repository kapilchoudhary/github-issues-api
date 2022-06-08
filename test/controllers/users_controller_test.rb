require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JsonWebToken.encode(email: @user.email)
  end

  test "should get index" do
    get users_url, headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post users_url, params: { user: { name: "John", username: "john12", email: "john@doe.com", password: "123456" } }, as: :json
    end

    assert_response :success
  end

  test "should show user" do
    get user_url(@user), params: { user: { id: 1 } }, headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { username: "test12"}, headers: { 'Authorization' => @token }, as: :json

    @user.reload
    assert_equal @user.username, "test12"
    assert_response :success
  end
end
