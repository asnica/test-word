class AddCorrectAnswerToQuizQuestions < ActiveRecord::Migration[8.1]
  def up
    add_column :quiz_questions, :correct_answer, :string

    execute <<~SQL
      UPDATE quiz_questions
      SET correct_answer = words.meaning
      FROM words
      WHERE words.id = quiz_questions.word_id
    SQL
  end

  def down
    remove_column :quiz_questions, :correct_answer
  end
end
