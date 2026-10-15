class QuizQuestion < ApplicationRecord
  belongs_to :quiz
  belongs_to :word, -> { unscope(where: :deleted_at) }
end
