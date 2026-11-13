require "test_helper"

class RankingsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to login when not logged in" do
    get rankings_url

    assert_redirected_to login_path
  end
  test "should rank users using only completed quizzes" do
    post login_path, params: {
      email: users(:one).email,
      password: "password"
    }

    get rankings_url

    assert_response :success

    assert_select "tbody tr", count: 1
    assert_select "tbody tr td", text: "Test User"
    assert_select "tbody tr td", text: "0.0％"
    assert_select "tbody tr td", text: "1位"

    assert_select "tbody tr td", text: "Test User Two", count: 0
  end
    test "should rank users by correct rate" do
    quizzes(:two).update!(completed: true)

    post login_path, params: {
      email: users(:one).email,
      password: "password"
    }

    get rankings_url

    assert_response :success

    assert_select "tbody tr", count: 2

    assert_select "tbody tr:nth-child(1)" do
      assert_select "td", text: "1位"
      assert_select "td", text: "Test User Two"
      assert_select "td", text: "100.0％"
    end

    assert_select "tbody tr:nth-child(2)" do
      assert_select "td", text: "2位"
      assert_select "td", text: "Test User"
      assert_select "td", text: "0.0％"
    end
  end

    test "should rank users by correct count when correct rates are equal" do
    quizzes(:two).update!(completed: true)

    quiz_questions(:one).update!(
      selected_answer: quiz_questions(:one).correct_answer
    )

    quizzes(:one).quiz_questions.create!(
      word: words(:two),
      position: 2,
      selected_answer: "MyString",
      correct_answer: "MyString"
    )

    post login_path, params: {
      email: users(:one).email,
      password: "password"
    }

    get rankings_url

    assert_response :success

    assert_select "tbody tr:nth-child(1)" do
      assert_select "td", text: "1位"
      assert_select "td", text: "Test User"
      assert_select "td", text: "100.0％"
    end

    assert_select "tbody tr:nth-child(2)" do
      assert_select "td", text: "2位"
      assert_select "td", text: "Test User Two"
      assert_select "td", text: "100.0％"
    end

    assert_select "p", text: /2問中\s*2問正解/
  end
end
