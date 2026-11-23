class User < ApplicationRecord
  has_many :words
  has_many :tags
  has_many :quizzes, dependent: :destroy

  has_secure_password

  scope :with_quiz_stats, -> {
    left_joins(quizzes: :quiz_questions)
    .where(quizzes: { completed: true })
    .group("users.id")
    .select(
      "users.*",
      "COUNT(quiz_questions.id) AS total_count",
      "SUM(CASE WHEN quiz_questions.selected_answer = quiz_questions.correct_answer THEN 1 ELSE 0 END) AS correct_count",
      "COALESCE(ROUND(SUM(CASE WHEN quiz_questions.selected_answer = quiz_questions.correct_answer THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(quiz_questions.id), 0), 1), 0) AS correct_rate"
    )
    .order("correct_rate DESC, correct_count DESC, users.id ASC")
  }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
