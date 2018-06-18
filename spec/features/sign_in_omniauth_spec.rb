require_relative 'acceptance_helper'

feature 'Authorization from providers', %{
  In order to have access to app
  As a user
  I want to be able to sign in with my social network accounts
} do

  describe 'vkontakte' do
    scenario 'log in user', js: true do
      user = create(:user, email: 'change@me.please')
      auth = mock_auth_hash(:vkontakte, user.email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email to continue'

      fill_in 'email', with: 'test@me.com'
      click_on 'Set my email'

      current_email.save_and_open
      #expect(page).to have_content('Successfully authenticated from Vkontakte account.')
    end

    scenario 'sign up user' do
      #user = create(:user, email: 'change@me.please')
      #auth = mock_auth_hash(:vkontakte, email: user.email)

      #create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path

      click_on 'Sign in with Vkontakte'





      open_email('test@me.com')
      current_email.click_link 'Confirm!'
      expect(page).to have_content('You have successfully signed up and signed in, welcome!')
    end
  end

  describe 'github' do
    scenario 'sign up user' do
      visit new_user_session_path

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Enter your email to continue'

      fill_in 'email', with: 'test@me.com'
      click_on 'Set my email'

      open_email('test@me.com')
      current_email.click_link 'Confirm!'

      expect(page).to have_content('You have successfully signed up and signed in, welcome!')
    end

    scenario 'log in user', js: true do
      user = create(:user, email: 'test@me.please')
      auth = mock_auth_hash(:github, user.email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from GitHub account.')
    end
  end
end
