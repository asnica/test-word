
require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  def login_as(user)
  post login_path, params: {
    email: user.email,
    password: "password"
  }
  assert_redirected_to main_menu_path
  end

  test "should create tag" do
    user = User.create!(
      name: "Test User",
      email: "create@example.com",
      password: "password",
      password_confirmation: "password"
    )

  login_as(user)

  assert_difference("Tag.count", 1) do
    post tags_path, params: {
      tag: {
        name: "animal"
      }
    }
  end

  assert_redirected_to tags_path
  end

  test "should destroy tag" do
    user = users(:one)
    tag = tags(:one)

  login_as(user)

  assert_difference("Tag.count", -1) do
    delete tag_path(tag)
  end

  assert_redirected_to tags_path
  end

  test "should update tag" do
  user = users(:one)
  tag = tags(:one)

  login_as(user)

  patch tag_path(tag), params: {
    tag: {
      name: "animal"
    }
  }

  assert_redirected_to tags_path
  assert_equal "animal", tag.reload.name
  end

  test "should get index" do
  user = users(:one)

  login_as(user)

  get tags_path

  assert_response :success
  end

  test "should search tags case insensitively" do
    user = User.create!(
      name: "Search User",
      email: "tag-search@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    Tag.create!(user: user, name: "Apple")
    Tag.create!(user: user, name: "Banana")

    get tags_path, params: { keyword: "apple" }

    assert_response :success
    assert_select "body", text: /Apple/
    assert_select "body", text: /Banana/, count: 0
  end

  test "should treat percent and underscore as literal characters" do
    user = User.create!(
      name: "Special Search User",
      email: "tag-special-search@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    Tag.create!(user: user, name: "100%")
    Tag.create!(user: user, name: "1000")
    Tag.create!(user: user, name: "test_name")
    Tag.create!(user: user, name: "testXname")

    get tags_path, params: { keyword: "%" }

    assert_response :success
    assert_select "body", text: /100%/
    assert_select "body", text: /1000/, count: 0

    get tags_path, params: { keyword: "_" }

    assert_response :success
    assert_select "body", text: /test_name/
    assert_select "body", text: /testXname/, count: 0
  end

  test "should not search another user's tags" do
    user = User.create!(
      name: "Search User",
      email: "tag-scope@example.com",
      password: "password",
      password_confirmation: "password"
    )

    other_user = User.create!(
      name: "Other User",
      email: "other-tag-scope@example.com",
      password: "password",
      password_confirmation: "password"
    )

    Tag.create!(user: user, name: "MyApple")
    Tag.create!(user: other_user, name: "OtherApple")

    login_as(user)

    get tags_path, params: { keyword: "Apple" }

    assert_response :success
    assert_select "body", text: /MyApple/
    assert_select "body", text: /OtherApple/, count: 0
  end
end
