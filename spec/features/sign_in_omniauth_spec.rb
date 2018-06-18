require_relative 'acceptance_helper'

feature 'Authorization from providers', %{
  In order to have access to app
  As a user
  I want to be able to sign in with my social network accounts
} do

  let(:user) { create(:user, email: 'change@me.please') }

  describe 'vkontakte' do
    scenario 'sign up user' do
      visit new_user_session_path

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email to continue'

      fill_in 'user_email', with: 'test@me.com'
      click_on 'Set my email'

      open_email('test@me.com')
      current_email.click_link 'Confirm my email'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'log in user' do
      auth = mock_auth_hash(:vkontakte, user.email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content('Successfully authenticated from Vkontakte account.')
    end
  end

  describe 'github' do
    scenario 'sign up user' do
      visit new_user_session_path

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Enter your email to continue'

      fill_in 'user_email', with: 'test@me.com'
      click_on 'Set my email'

      open_email('test@me.com')
      current_email.click_link 'Confirm my email'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'log in user' do
      auth = mock_auth_hash(:github, user.email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from GitHub account.')
    end
  end
end
