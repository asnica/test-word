class WordsController < ApplicationController
  def index
    @words = User.first.words
  end

  def new
    @word = Word.new
  end

  def create
    user = User.first

    @word = user.words.new(
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
    @word = Word.find(params[:id])

    if @word.update(
      word: params[:word],
      meaning: params[:meaning]
    )
      redirect_to words_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    word = Word.find(params[:id])
    word.destroy

    redirect_to words_path
  end
end
