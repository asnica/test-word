class Word < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  belongs_to :user

  has_many :word_tags
  has_many :tags, through: :word_tags
  has_many :synonyms
  accepts_nested_attributes_for :synonyms, 
  allow_destroy: true, reject_if: :all_blank
  # synonymsテーブルのデータを同時に保存するための設定。
  # allow_destroy: trueは、synonymsのデータを削除できるようにするための設定。
  #reject_if: :all_blankは、synonymsのデータが空の場合は保存しないようにするための設定。

  has_one_attached :image

  # word, meaningの空欄禁止(スペースだけでも空欄とみなす)
  validates :word, :meaning, presence: true
  # wordの重複禁止
  validates :word, uniqueness: { 
    scope: :user_id, 
    conditions: -> { where(deleted_at: nil)
    }
  }
end
