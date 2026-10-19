class RankingsController < ApplicationController
  before_action :require_login

  def index
    users = User
      .joins(:quizzes)
      .where(quizzes: { completed: true })
      .distinct
      .includes(quizzes: { quiz_questions: :word })

    @rankings = users.map do |user|
      completed_quizzes = user.quizzes.select(&:completed?)

      questions = completed_quizzes.flat_map(&:quiz_questions)

      total_count = questions.size

      correct_count = questions.count do |question|
        question.selected_answer == question.word.meaning
      end

      correct_rate =
        if total_count.zero?
          0
        else
          (correct_count.to_f / total_count * 100).round(1)
        end

      {
        user: user,
        total_count: total_count,
        correct_count: correct_count,
        correct_rate: correct_rate
      }
    end

    @rankings.sort_by! do |ranking|
      [ -ranking[:correct_rate], -ranking[:correct_count] ]
    end

    @rankings.each_with_index do |ranking, index|
      ranking[:rank] = index + 1
    end

    @my_ranking = @rankings.find do |ranking|
      ranking[:user].id == current_user.id
    end
  end
end
