require_relative 'acceptance_helper'

feature 'User can sign up', %q{
  In order to be able to create questions and answers
  As an user
  I want to be able to sign up
} do
  given(:user) { create(:user) }

  scenario 'New user can sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to sign up again' do
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq user_registration_path
  end
end
