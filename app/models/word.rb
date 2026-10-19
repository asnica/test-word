class Word < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  belongs_to :user

  has_many :word_tags
  has_many :tags, through: :word_tags
  has_many :synonyms
  accepts_nested_attributes_for :synonyms, allow_destroy: true, reject_if: :all_blank

  has_one_attached :image

  validates :word, uniqueness: { scope: :user_id, conditions: -> { where(deleted_at: nil) } }
end
