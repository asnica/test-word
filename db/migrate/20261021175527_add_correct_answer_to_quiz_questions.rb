class AddCorrectAnswerToQuizQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :quiz_questions, :correct_answer, :string
  end
end
