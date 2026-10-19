class QuizzesController < ApplicationController
  before_action :require_login

  def index
  @page = [ params.fetch(:page, 1).to_i, 1 ].max
  @per_page = 4

  quizzes = current_user.quizzes
                        .includes(quiz_questions: :word)
                        .order(created_at: :desc)

  @total_pages = (quizzes.count.to_f / @per_page).ceil

  @quizzes = quizzes
               .offset((@page - 1) * @per_page)
               .limit(@per_page)
  end

  def create
  words = current_user.words.order("RANDOM()").limit(10)

  if words.size < 10
    redirect_to quizzes_path,
                alert: "問題集を始めるには単語を10個以上登録してください。"
    return
  end

  quiz = current_user.quizzes.create!

  words.each_with_index do |word, index|
    quiz.quiz_questions.create!(
      word: word,
      position: index + 1
    )
  end

  redirect_to quiz_path(quiz)
end

def show
  @quiz = current_user.quizzes.find(params[:id])
  if params[:position].present?
  position = params[:position]
  else
  unanswered = @quiz.quiz_questions
                    .where(selected_answer: nil)
                    .order(:position)
                    .first

  position = unanswered ? unanswered.position : 1
  end

@quiz_question = @quiz.quiz_questions.find_by!(
  position: position
)

prepare_choices
end

def answers
  @quiz = current_user.quizzes.find(params[:id])
  @quiz_questions = @quiz.quiz_questions.includes(:word).order(:position)
end

def answer
  @quiz = current_user.quizzes.find(params[:id])

  @quiz_question = @quiz.quiz_questions.find_by!(
    position: params[:position]
  )

  @quiz_question.update!(
    selected_answer: params[:answer]
  )

  if @quiz_question.position == 10
    redirect_to answers_quiz_path(@quiz)
    return
  end

  next_position = @quiz_question.position + 1

  @quiz_question = @quiz.quiz_questions.find_by!(
    position: next_position
  )

  prepare_choices

  respond_to do |format|
    format.turbo_stream
    format.html do
      redirect_to quiz_path(@quiz, position: next_position)
    end
  end
end

def result
  @quiz = current_user.quizzes.find(params[:id])
  @quiz_questions = @quiz.quiz_questions.includes(:word).order(:position)

  @correct_count = @quiz_questions.count do |question|
    question.selected_answer == question.word.meaning
  end
end

def retry
  old_quiz = current_user.quizzes.find(params[:id])

  new_quiz = current_user.quizzes.create!

  old_quiz.quiz_questions.order(:position).each do |question|
    new_quiz.quiz_questions.create!(
      word: question.word,
      position: question.position
    )
  end

  redirect_to quiz_path(new_quiz)
end

def grade
  @quiz = current_user.quizzes.find(params[:id])

  @quiz.update!(completed: true)

  redirect_to result_quiz_path(@quiz)
end

private

def prepare_choices
  correct_answer = @quiz_question.word.meaning

  wrong_answers = current_user.words
                              .where.not(id: @quiz_question.word_id)
                              .where.not(meaning: correct_answer)
                              .order("RANDOM()")
                              .limit(2)
                              .pluck(:meaning)

  @choices = (wrong_answers + [ correct_answer ]).shuffle
end
end
