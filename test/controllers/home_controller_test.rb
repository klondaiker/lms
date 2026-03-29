require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(login: "testuser", password: "password123")
  end

  test "GET root when not logged in redirects to login" do
    get root_url
    assert_redirected_to new_session_url
  end

  test "GET root when logged in shows greeting" do
    post sessions_url, params: { login: "testuser", password: "password123" }
    get root_url
    assert_response :success
    assert_match "Привет, testuser", response.body
  end
end
