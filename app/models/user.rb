class User < ApplicationRecord
  has_many :words

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end