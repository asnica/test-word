require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name is required" do
    user = User.new(name: "", email: "test@example.com")
    assert_not user.valid?
  end

  test "email is required" do
    user = User.new(name: "Test User", email: "")
    assert_not user.valid?
  end

  test "email must be unique" do
    User.create(name: "Existing User", email: "existing@example.com")
    user = User.new(name: "New User", email: "existing@example.com")
    assert_not user.valid?
  end

  test "valid user" do
    user = User.new(name: "Valid User", email: "valid@example.com")
    assert user.valid?
  end
end
