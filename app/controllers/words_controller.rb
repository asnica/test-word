class WordsController < ApplicationController

before_action :require_login

  def index
    @words = current_user.words
  end

  def show
    @word = Word.find(params[:id])
  end

  def new
    @word = Word.new
  end

  def create

    @word = current_user.words.new(
      word: params[:word],
      meaning: params[:meaning]
    )

    if @word.save
      redirect_to words_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @word = Word.find(params[:id])
  end

def update
  @word = current_user.words.find(params[:id])

  if @word.update(word_params)
    redirect_to word_path(@word)
  else
    render :edit, status: :unprocessable_entity
  end
end

  def destroy
    word = current_user.words.find(params[:id])
    word.destroy

    redirect_to words_path
  end

  private

  def word_params
    params.require(:word).permit(:word, :meaning)
  end
end
