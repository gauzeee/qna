require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do

    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Body text'
    click_on 'Save'

    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content Question.last.title
    expect(page).to have_content Question.last.body
  end

  scenario 'Authenticated user creates question with invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Save'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
    end

  fcontext 'multiple sessions' do
    scenario 'question appears on another users page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Body text'
        click_on 'Save'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end


  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'
  end
end
