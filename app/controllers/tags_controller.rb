class TagsController < ApplicationController
  before_action :require_login
  before_action :set_tag, only: [ :edit, :update, :destroy ]

  def index
    @tags = current_user.tags

    if params[:keyword].present?
      keyword = ActiveRecord::Base.sanitize_sql_like(params[:keyword])
      @tags = @tags.where("name LIKE ?", "%#{keyword}%")
    end
  end

  def new
    @tag = current_user.tags.new
  end

  def create
    @tag = current_user.tags.new(tag_params)

  if @tag.save
    redirect_to tags_path, notice: "タグを追加しました。"
  else
    render :new, status: :unprocessable_entity
  end
end

def edit
end

def update
  if @tag.update(tag_params)
    redirect_to tags_path, notice: "タグを更新しました。"
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @tag.destroy
  redirect_to tags_path, notice: "タグを削除しました。"
end

  private

  def set_tag
  @tag = current_user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
