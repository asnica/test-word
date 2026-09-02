class WordsController < ApplicationController
  before_action :require_login
  before_action :set_word, only: [:show, :edit, :update, :destroy]

 def index
  @words = current_user.words

  if params[:keyword].present?
    @words = @words.where("word LIKE ? OR meaning LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
  end
end

  def show
  end

  def new
    @word = Word.new
    @tags = Tag.all
  end

  def create
  @word = current_user.words.new(word_params)

  if @word.save
    @word.tag_ids = params[:tag_ids]
    redirect_to words_path
  else
    @tags = Tag.all
    render :new, status: :unprocessable_entity
  end
end

  def edit
    @tags = Tag.all
  end

 def update
  if @word.update(word_params)
    @word.tag_ids = params[:tag_ids] || []

    @word.synonyms.destroy_all

    params[:synonyms].to_s.split(",").map(&:strip).reject(&:blank?).uniq.each do |name|
      @word.synonyms.create(name: name)
    end

    redirect_to word_path(@word)
  else
    @tags = Tag.all
    render :edit, status: :unprocessable_entity
  end
end

  def destroy
    @word.update(deleted_at: Time.current)
    redirect_to words_path
  end

  private

  def set_word
    @word = current_user.words.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:word, :meaning)
  end
end