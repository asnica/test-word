require "test_helper"

class QuizRegressionTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "alice", email: "alice@example.com", password: "password")
    post login_path, params: { email: @user.email, password: "password" }
  end

  # シナリオ2: 採点後に単語の意味を編集しても、過去の採点結果が変わらないこと
  test "editing word meaning does not change past result" do
    add_words((1..10).map { |i| [ "word#{i}", "意味#{i}" ] })
    quiz = start_quiz
    answer_all(quiz, correct: [ 1 ])
    post grade_quiz_path(quiz)

    quiz.quiz_questions.each do |question|
      patch word_path(question.word), params: { word: { meaning: "わからない" } }
    end

    assert_equal 1, correct_count(quiz)
  end

  # シナリオ3: 異なる意味が3種類未満の場合、クイズを作成できないこと
  test "cannot start quiz with fewer than 3 distinct meanings" do
    add_words((1..9).map { |i| [ "看る#{i}", "見る" ] } + [ [ "聞く", "聴く" ] ])

    assert_no_difference -> { Quiz.count } do
      post quizzes_path
    end
  end

  # シナリオ3: 同じ意味の単語があっても、選択肢が常に重複なしの3つであること
  test "choices are always 3 distinct values" do
    add_words([ [ "犬", "dog" ], [ "猫", "cat" ] ] + (1..8).map { |i| [ "看る#{i}", "見る" ] })
    quiz = start_quiz
    question = quiz.quiz_questions.joins(:word).find_by(words: { word: "犬" })

    # 選択肢はランダムなので、複数回表示して確認する
    20.times do
      get quiz_path(quiz, position: question.position)
      assert_equal %w[cat dog 見る], choices.sort
    end
  end

  private

  def add_words(pairs)
    pairs.each { |word, meaning| @user.words.create!(word: word, meaning: meaning) }
  end

  def start_quiz
    post quizzes_path
    @user.quizzes.order(:id).last
  end

  def answer_all(quiz, correct:)
    quiz.quiz_questions.order(:position).each do |question|
      answer = correct.include?(question.position) ? question.correct_answer : "わからない"
      patch answer_quiz_path(quiz), params: { position: question.position, answer: answer }
    end
  end

  def correct_count(quiz)
    get result_quiz_path(quiz)
    response.body[/(\d+) \/ 10 正解/, 1].to_i
  end

  def choices
    response.body.scan(/type="radio" name="answer" id="[^"]*" value="([^"]*)"/).flatten
  end
end
