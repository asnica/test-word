class RankingsController < ApplicationController
  before_action :require_login

  def index
    users = User.with_quiz_stats

    @rankings = users.map.with_index do |user, index|
      {
        user: user,
        total_count: user.total_count,
        correct_count: user.correct_count,
        correct_rate: user.correct_rate.to_f,
        rank: index + 1
      }
    end

    @my_ranking = @rankings.find do |ranking|
      ranking[:user].id == current_user.id
    end
  end
end
