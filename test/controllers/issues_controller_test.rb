require "test_helper"

class IssuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @issue = issues(:one)
    @user = users(:one)
    @token = JsonWebToken.encode(email: @user.email)
  end

  test "should get index" do
    get issues_url, headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "should create issue" do
    assert_difference("Issue.count", 1) do
      post issues_url, params: { issue: { title: "issue", description: "this is issue description", user: @user } }, headers: { 'Authorization' => @token }, as: :json
    end

    assert_response :success
  end

  test "should show issue" do
    get issue_url(@issue), headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "should update issue" do
    patch issue_url(@issue), params: { id: 1 }, headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "should destroy issue" do
    assert_difference("Issue.count", -1) do
      delete issue_url(@issue), headers: { 'Authorization' => @token }, as: :json
    end

    assert_response :success
  end

  test "filter issue by id" do
    get issues_url, params: { id: 1 }, headers: { 'Authorization' => @token }, as: :json

    assert_response :success
  end
end
