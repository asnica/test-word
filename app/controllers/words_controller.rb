class WordsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :word_not_found

  before_action :require_login
  before_action :set_word, only: [:show, :edit, :update, :destroy]
  before_action :set_tags, only: [:new, :create, :edit, :update]

  def index
    @words = current_user.words.includes(:tags, :synonyms)

    if params[:keyword].present?
      keyword = ActiveRecord::Base.sanitize_sql_like(params[:keyword])

      @words = @words
        .left_joins(:tags)
        .where(
          "words.word LIKE :keyword
           OR words.meaning LIKE :keyword
           OR tags.name LIKE :keyword",
          keyword: "%#{keyword}%"
        )
        .distinct
    end
  end

  def show
  end

  def new
    @word = Word.new
    @word.synonyms.build
  end

  def create
    @word = current_user.words.new(word_params)

    if @word.save
      @word.tag_ids = permitted_tag_ids if params.key?(:tag_ids)

      redirect_to words_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @word.update(word_params)
      @word.tag_ids = permitted_tag_ids if params.key?(:tag_ids)

      redirect_to word_path(@word)
    else
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

def set_tags
  @tags = current_user.tags
end

def word_not_found
  render "words/not_found", status: :not_found
end

def permitted_tag_ids
  current_user.tags.where(id: params[:tag_ids]).pluck(:id)
end

def word_params
  params.require(:word).permit(
    :word,
    :meaning,
    synonyms_attributes: [:id, :name, :_destroy]
  )
end
end