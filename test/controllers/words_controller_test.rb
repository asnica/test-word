require "test_helper"

class WordsControllerTest < ActionDispatch::IntegrationTest
  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: "password"
    }
    assert_redirected_to main_menu_path
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
      tag_ids: [ tag.id ]
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

  test "should search words case insensitively" do
    user = User.create!(
      name: "Word Search User",
      email: "word-search@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    Word.create!(
      user: user,
      word: "Apple",
      meaning: "りんご"
    )

    Word.create!(
      user: user,
      word: "Banana",
      meaning: "バナナ"
    )

    get words_path, params: { keyword: "apple" }

    assert_response :success
    assert_select "body", text: /Apple/
    assert_select "body", text: /Banana/, count: 0
  end

  test "should search word meanings case insensitively" do
    user = User.create!(
      name: "Meaning Search User",
      email: "meaning-search@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    Word.create!(
      user: user,
      word: "apple",
      meaning: "Red Fruit"
    )

    Word.create!(
      user: user,
      word: "banana",
      meaning: "Yellow Fruit"
    )

    get words_path, params: { keyword: "red" }

    assert_response :success
    assert_select "body", text: /Red Fruit/
    assert_select "body", text: /Yellow Fruit/, count: 0
  end

  test "should search words by tag name case insensitively" do
    user = User.create!(
      name: "Tag Search User",
      email: "word-tag-search@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    tag = Tag.create!(
      user: user,
      name: "Fruit"
    )

    apple = Word.create!(
      user: user,
      word: "Apple",
      meaning: "りんご"
    )

    Word.create!(
      user: user,
      word: "Car",
      meaning: "車"
    )

    apple.tags << tag

    get words_path, params: { keyword: "fruit" }

    assert_response :success
    assert_select "body", text: /Apple/
    assert_select "body", text: /Car/, count: 0
  end

  test "should treat percent and underscore as literal characters in word search" do
    user = User.create!(
      name: "Special Word Search User",
      email: "word-special-search@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    Word.create!(user: user, word: "100%", meaning: "percentage")
    Word.create!(user: user, word: "1000", meaning: "number")
    Word.create!(user: user, word: "test_name", meaning: "underscore")
    Word.create!(user: user, word: "testXname", meaning: "other")

    get words_path, params: { keyword: "%" }

    assert_response :success
    assert_select "body", text: /100%/
    assert_select "body", text: /1000/, count: 0

    get words_path, params: { keyword: "_" }

    assert_response :success
    assert_select "body", text: /test_name/
    assert_select "body", text: /testXname/, count: 0
  end

  test "should not search another user's words" do
    user = User.create!(
      name: "Search User",
      email: "word-scope@example.com",
      password: "password",
      password_confirmation: "password"
    )

    other_user = User.create!(
      name: "Other User",
      email: "other-word-scope@example.com",
      password: "password",
      password_confirmation: "password"
    )

    Word.create!(
      user: user,
      word: "MyApple",
      meaning: "自分の単語"
    )

    Word.create!(
      user: other_user,
      word: "OtherApple",
      meaning: "他人の単語"
    )

    login_as(user)

    get words_path, params: { keyword: "Apple" }

    assert_response :success
    assert_select "body", text: /MyApple/
    assert_select "body", text: /OtherApple/, count: 0
  end

  test "should create word without selected tags" do
    user = User.create!(
      name: "No Tag User",
      email: "no-tag@example.com",
      password: "password",
      password_confirmation: "password"
    )

    login_as(user)

    assert_difference("Word.count", 1) do
      post words_path, params: {
        word: {
          word: "apple",
          meaning: "りんご"
        },
        tag_ids: [ "" ]
      }
    end

    assert_redirected_to words_path

    word = user.words.find_by!(word: "apple")
    assert_empty word.tags
  end
end
