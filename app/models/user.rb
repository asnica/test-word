class User < ApplicationRecord
  has_many :words
  has_many :tags

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
