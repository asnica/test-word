require "test_helper"

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  setup do
    post login_path, params: {
      email: users(:one).email,
      password: "password"
    }
  end

  test "cannot change answer after quiz is completed" do
    quiz = quizzes(:one)
    question = quiz_questions(:one)

    assert_no_changes -> { question.reload.selected_answer } do
      patch answer_quiz_path(quiz), params: {
        position: question.position,
        answer: "new_answer"
      }
    end

    assert_redirected_to result_quiz_path(quiz)
  end

  test "does not overwrite selected answer with nil when answer is blank" do
    quiz = quizzes(:in_progress)
    question = quiz_questions(:in_progress)

    assert_no_changes -> { question.reload.selected_answer } do
      patch answer_quiz_path(quiz), params: {
        position: question.position
      }
    end
  end
end