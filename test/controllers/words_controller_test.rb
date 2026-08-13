require "test_helper"

class WordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get words_path
    assert_response :success
  end

  test "should get new" do
    get "/words/new"
    assert_response :success
  end

  test "should create word" do
    user = User.first

    assert_difference("Word.count", 1) do
      post words_path, params: {
        word: "banana",
        meaning: "バナナ"
      }
    end

    assert_redirected_to words_path
  end

  test "should edit word" do
    word = Word.create!(
      user: User.first,
      word: "orange",
      meaning: "オレンジ"
    )

    get "/words/#{word.id}/edit"

    assert_response :success
  end

  test "should update word" do
    word = Word.create!(
      user: User.first,
      word: "grape",
      meaning: "ぶどう"
    )

    patch "/words/#{word.id}", params: {
      word: "grape",
      meaning: "ブドウ"
    }

    assert_redirected_to words_path
    assert_equal "ブドウ", word.reload.meaning
  end

  test "should destroy word" do
    word = Word.create!(
      user: User.first,
      word: "melon",
      meaning: "メロン"
    )

    assert_difference("Word.count", -1) do
      delete "/words/#{word.id}"
    end

    assert_redirected_to words_path
  end
end
