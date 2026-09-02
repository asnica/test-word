class Word < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  belongs_to :user

  has_many :word_tags
  has_many :tags, through: :word_tags
  has_many :synonyms
  
  validates :word, uniqueness: { scope: :user_id, conditions: -> { where(deleted_at: nil) } }
end
