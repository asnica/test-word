require "test_helper"

class MainMenuControllerTest < ActionDispatch::IntegrationTest
  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: "password"
    }
    assert_redirected_to main_menu_path
  end

  test "should get index" do
    user = users(:one)

    login_as(user)

    get main_menu_path

    assert_response :success
  end

  test "should redirect guest to login" do
    get main_menu_path

    assert_redirected_to login_path
  end
end
