require "test_helper"

class WordsControllerTest < ActionDispatch::IntegrationTest
  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: "password"
    }
    assert_redirected_to words_path
  end

test "should get index" do
  user = User.create!(
    name: "Test User",
    email: "index@example.com",
    password: "password",
    password_confirmation: "password"
  )

  login_as(user)

  get words_path

  assert_response :success
end

  test "should get new" do
    user = User.create!(
      name: "Test User",
      email: "new@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    get "/words/new"

    assert_response :success
  end

  test "should create word" do
    user = User.create!(
      name: "Test User",
      email: "create@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    assert_difference("Word.count", 1) do
      post words_path, params: {
        word: {
          word: "banana",
        meaning: "バナナ"
        }
      }
    end

    assert_redirected_to words_path
  end

  test "should edit word" do
    user = User.create!(
      name: "Test User",
      email: "edit@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    word = Word.create!(
      user: user,
      word: "orange",
      meaning: "オレンジ"
    )

    get "/words/#{word.id}/edit"

    assert_response :success
  end

  test "should update word" do
    user = User.create!(
      name: "Test User",
      email: "update@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    word = Word.create!(
      user: user,
      word: "grape",
      meaning: "ぶどう"
    )

    patch "/words/#{word.id}", params: {
      word: {
        word: "grape",
        meaning: "ブドウ"
      }
    }

    assert_redirected_to word_path(word)
    assert_equal "ブドウ", word.reload.meaning
  end

    test "should not assign another user's tag to word" do
    user = User.create!(
      name: "User A",
      email: "tag-owner@example.com",
      password: "password",
      password_confirmation: "password"
    )

    other_user = User.create!(
      name: "User B",
      email: "other-tag-owner@example.com",
      password: "password",
      password_confirmation: "password"
    )

    tag = Tag.create!(
      name: "other-user-tag",
      user: other_user
    )

    login_as(user)

    post words_path, params: {
      word: {
        word: "apple",
        meaning: "りんご"
      },
      tag_ids: [tag.id]
    }

    word = Word.order(:id).last

    assert_redirected_to words_path
    assert_not_includes word.tags, tag
  end
  
  test "should destroy word" do
    user = User.create!(
      name: "Test User",
      email: "destroy@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    word = Word.create!(
      user: user,
      word: "melon",
      meaning: "メロン"
    )

    assert_difference("Word.count", -1) do
      delete "/words/#{word.id}"
    end

    assert_redirected_to words_path
  end
end