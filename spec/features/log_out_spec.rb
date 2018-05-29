require_relative 'acceptance_helper'

feature 'Authenticated user can log out', %q{
  In order to be able lo exit from my account
  As an authenticated user
  I want to be able to log out
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user can log out' do
    sign_in(user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
