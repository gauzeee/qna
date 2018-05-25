require 'rails_helper'

feature 'User delete answer', %q{
  In order to be able to delte answer
  As an authenticated user
  I want to be able to delete answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: author) }

  before do
    question
    answer
  end

  scenario 'Author delete answer' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted.'
  end

  scenario 'Not author delete answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'You are not an author of this answer.'
  end
end
