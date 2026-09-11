class CreateSynonyms < ActiveRecord::Migration[8.1]
  def change
    create_table :synonyms do |t|
      t.references :word, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
