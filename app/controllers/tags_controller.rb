class TagsController < ApplicationController
  before_action :require_login
  before_action :set_tag, only: [ :edit, :update, :destroy ]

  # indexアクションでタグの一覧を取得 + 検索機能を追加
  def index
    @tags = current_user.tags

    if params[:keyword].present?
      keyword = ActiveRecord::Base.sanitize_sql_like(params[:keyword])
      @tags = @tags.where("name LIKE ?", "%#{keyword}%")
    end
  end

  # tagの新規作成する画面を表示するアクション
  def new
    @tag = current_user.tags.new
  end

  # tagの新規作成を受け取って保存するアクション
  def create
    @tag = current_user.tags.new(tag_params)

  if @tag.save
    redirect_to tags_path, notice: "タグを追加しました。"
  else
    render :new, status: :unprocessable_entity
  end
end

# tagの編集画面を表示するアクション
def edit
end

# tagの更新を受け取って保存するアクション
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

  # tagを取得するためのメソッド（現在ログインしているユーザーのタグのみを取得する）
  def set_tag
  @tag = current_user.tags.find(params[:id])
  end

  # tagのパラメータを取得するためのメソッド(nameのみを許可する)
  def tag_params
    params.require(:tag).permit(:name)
  end
end
