require_relative 'acceptance_helper'

feature 'Delete file from question', %q{
  In order to remove attachments
  As an author of question
  I'd like to be able to delete file
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:file) { create(:attachment, attachable: question)}

  describe 'Authenticate user' do
    scenario 'delete file of his question', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Delete file'

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'delete file of others question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Non-authenticate user try delete file' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete file'
  end
end
