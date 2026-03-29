require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(login: "testuser", password: "password123")
  end

  test "GET new returns login form" do
    get new_session_url
    assert_response :success
  end

  test "POST create with valid credentials logs in and redirects to root" do
    post sessions_url, params: { login: "testuser", password: "password123" }
    assert_redirected_to root_url
  end

  test "POST create with invalid credentials renders form with error" do
    post sessions_url, params: { login: "testuser", password: "wrongpassword" }
    assert_response :unprocessable_entity
  end

  test "DELETE destroy logs out and redirects to login" do
    post sessions_url, params: { login: "testuser", password: "password123" }
    delete session_url(id: "current")
    assert_redirected_to new_session_url
  end
end
