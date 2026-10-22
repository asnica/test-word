class CreateQuizQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_questions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :word, null: false, foreign_key: true
      t.string :selected_answer
      t.integer :position

      t.timestamps
    end
  end
end
