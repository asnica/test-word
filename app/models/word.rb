class Word < ApplicationRecord
  belongs_to :user

  validates :word, uniqueness: { scope: :user_id }
end
