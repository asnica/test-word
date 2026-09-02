class AddDeletedAtToWords < ActiveRecord::Migration[8.1]
  def change
    add_column :words, :deleted_at, :datetime
  end
end
