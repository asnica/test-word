require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name is required" do
    user = User.new(name: "", email: "test@example.com")
    assert_not user.valid?
  end

  test "email is required" do
    user = User.new(
      name: "Valid User",
      email: ""
    )
    assert_not user.valid?
  end

  test "email must be unique" do
    User.create(
      name: "Existing User",
      email: "existing@example.com",
      password: "password",
      password_confirmation: "password"
    )

    user = User.new(
      name: "New User",
      email: "existing@example.com",
      password: "password",
      password_confirmation: "password"
    )

    assert_not user.valid?
  end

  test "valid user" do
    user = User.new(
      name: "Valid User",
      email: "valid@example.com",
      password: "password",
      password_confirmation: "password"
    )

    assert user.valid?
  end
end