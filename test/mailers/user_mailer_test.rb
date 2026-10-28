require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "registration complete should send correct email" do
    user = users(:one)
    email = UserMailer.registration_complete(user)

    assert_equal [ user.email ], email.to
    assert_equal "単語帳の新規登録完了のお知らせ", email.subject
  end
end
