class Synonym < ApplicationRecord
  belongs_to :word

  validates :name, presence: true, uniqueness: { scope: :word_id }
end
