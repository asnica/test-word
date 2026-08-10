require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_new_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post users_url, params: { user: { name: "ControllerTest User", email: "controller-test@example.com" } }
    end

    assert_redirected_to root_path
  end
end
