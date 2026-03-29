require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "GET new returns registration form" do
    get new_user_url
    assert_response :success
  end

  test "POST create with valid data creates user and redirects to login" do
    assert_difference "User.count", 1 do
      post users_url, params: { user: { login: "newuser", password: "password123" } }
    end
    assert_redirected_to new_session_url
  end

  test "POST create with duplicate login renders form with error" do
    User.create!(login: "existing", password: "password123")

    assert_no_difference "User.count" do
      post users_url, params: { user: { login: "existing", password: "password123" } }
    end
    assert_response :unprocessable_entity
  end
end
