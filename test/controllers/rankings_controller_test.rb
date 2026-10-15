require "test_helper"

class RankingsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to login when not logged in" do
    get rankings_url

    assert_redirected_to login_path
  end
end