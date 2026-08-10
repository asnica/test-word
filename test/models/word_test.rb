require "test_helper"

class WordTest < ActiveSupport::TestCase
  test "is invalid without a user" do
    word = Word.new(word: "book", meaning: "本", user_id: nil)

    assert_not word.valid?
  end

  test "is valid with a user" do
    user = User.create(name: "Test User", email: "test@example.com")
    word = Word.new(word: "book", meaning: "本", user: user)
    assert word.valid?
  end
end