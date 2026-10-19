class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
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

 def user_params
  params.require(:user).permit(
    :name,
    :email,
    :password,
    :password_confirmation
  )
 end
end
