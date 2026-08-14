class CreateWords < ActiveRecord::Migration[8.1]
  def change
    create_table :words do |t|
      t.string :word
      t.string :meaning
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
