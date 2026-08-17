class Word < ApplicationRecord
  belongs_to :user

  has_many :word_tags
  has_many :tags, through: :word_tags
  
  validates :word, uniqueness: { scope: :user_id }
end
