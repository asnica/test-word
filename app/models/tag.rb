class Tag < ApplicationRecord
  has_many :word_tags
  has_many :words, through: :word_tags
end