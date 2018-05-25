FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end

  sequence :body do |n|
    "Question#{n}"
  end

  factory :question do
    title
    body
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
