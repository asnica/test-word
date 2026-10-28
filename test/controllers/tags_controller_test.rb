# Tag Controllerが正しく動作するかのテスト
require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  def login_as(user)
  post login_path, params: {
    email: user.email,
    password: "password"
  }
  assert_redirected_to words_path
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
end
