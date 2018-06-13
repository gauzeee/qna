require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I`d like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Body text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds some files when asks question', js: true do

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Body text'
    click_on 'Add file'
    click_on 'Add file'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[1].set("#{Rails.root}/spec/spec_helper.rb")

    click_on 'Save'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
  end
end
