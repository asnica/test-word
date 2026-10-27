require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "registration complete should send correct email" do
    user = users(:one)
    email = UserMailer.registration_complete(user)

    # assert_equal 期待値(自分が書いたの）、 実際の値（コードから出したの）
    assert_equal [user.email], email.to #email.toは受取人
    assert_equal "単語帳の新規登録完了のお知らせ", email.subject
  end
end

# Action Mailer
# Railsが提供しているメール送信機能全体の仕組み。メールの作成や送信などの機能を提供する。

# ApplicationMailer
# アプリケーション内の各Mailerが共通して継承する基底クラス。共通の設定などを定義する。

# UserMailer
# ApplicationMailerを継承して作成したMailerクラス。ユーザーに関するメールの内容や送信処理を定義する。

# registration_complete
# UserMailer内に定義したメソッド。新規登録完了時に送るメールの宛先や件名などを定義する。