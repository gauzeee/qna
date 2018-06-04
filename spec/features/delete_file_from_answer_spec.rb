require_relative 'acceptance_helper'

feature 'Delete file from answer', %q{
  In order to remove attachments
  As an author of answer
  I'd like to be able to delete file
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question:question, user: author) }
  given!(:file) { create(:attachment, attachable: answer)}

  describe 'Authenticate user' do
    scenario 'delete file of his answer', js: true do
      sign_in(author)
      visit question_path(question)

      within('.answers') do
        click_on 'Delete file'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'delete file of others answer' do
      sign_in(user)
      visit question_path(question)

      within('.answers') do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  scenario 'Non-authenticate user try delete file' do
    visit question_path(question)
    within('.answers') do
      expect(page).to_not have_link 'Delete file'
    end
  end
end
