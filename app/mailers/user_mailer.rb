class UserMailer < ApplicationMailer
  def registration_complete(user)
    @user = user

    mail(
      to: @user.email,
      subject: "単語帳の新規登録完了のお知らせ"
    )
  end
end
