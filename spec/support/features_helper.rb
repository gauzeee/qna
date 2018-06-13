module FeaturesHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def new_answer(question)
    visit question_path(question)
    fill_in 'answer_body', with: 'Answer text'
    click_button 'New answer'
  end

  def one_more_answer(question)
    fill_in 'answer_body', with: 'One more answer'
    click_button 'New answer'
  end

  def new_invalid_answer(question)
    visit question_path(question)
    click_on 'New answer'
  end
end
