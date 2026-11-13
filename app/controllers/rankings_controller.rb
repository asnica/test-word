class RankingsController < ApplicationController
  before_action :require_login

  def index
    users = User
      .joins(:quizzes)
      .left_joins(quizzes: :quiz_questions)
      .where(quizzes: { completed: true })
      .group("users.id")
      .select(
        "users.*",
        "COUNT(quiz_questions.id) AS total_count",
        "SUM(CASE WHEN quiz_questions.selected_answer = quiz_questions.correct_answer THEN 1 ELSE 0 END) AS correct_count",
        "COALESCE(ROUND(SUM(CASE WHEN quiz_questions.selected_answer = quiz_questions.correct_answer THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(quiz_questions.id), 0), 1), 0) AS correct_rate"
      )
      .order("correct_rate DESC, correct_count DESC")

    @rankings = users.map.with_index do |user, index|
      {
        user: user,
        total_count: user.total_count,
        correct_count: user.correct_count,
        correct_rate: user.total_count.zero? ? 0 : user.correct_rate.to_f,
        rank: index + 1
      }
    end

    @my_ranking = @rankings.find do |ranking|
      ranking[:user].id == current_user.id
    end
  end
end
