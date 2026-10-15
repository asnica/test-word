class AddUserToTags < ActiveRecord::Migration[8.1]
  def change
    add_reference :tags, :user, foreign_key: true
  end
end
