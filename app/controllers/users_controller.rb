class UsersController < ApplicationController
  def new #ユーザー登録画面を表示するためのアクション / routes.rbでusers#newにルーティングされる
    @user = User.new
  end

  def create #ユーザー登録を行うためのアクション
    @user = User.new(user_params)
    if @user.save
      reset_session
      session[:user_id] = @user.id

      UserMailer.registration_complete(@user).deliver_later

      redirect_to words_path, notice: "新しいユーザーが作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  #javaのprivateメソッドと同じようなもの。
  #URLから要請を受けるメソッドはpublicメソッドである必要があるため、privateメソッドはURLから直接アクセスできない。
  private

 def user_params
  params.require(:user).permit(
    :name,
    :email,
    :password,
    :password_confirmation
  )
 end
end
