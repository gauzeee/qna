module FeaturesHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def new_answer(question)
    visit question_path(question)
    fill_in 'Your answer', with: 'Answer text'
    click_on 'New answer'
  end

  def new_invalid_answer(question)
    visit question_path(question)
    click_on 'Save'
  end
end
