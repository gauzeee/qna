# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'admin@qna.com', encrypted_password: 'password', admin: true, created_at: Time.now, confirmed_at: Time.now)

questions = Question.create([
  { title: 'The first question'}, { body: 'I want to ask you some...'}, { user_id: User.first.id },
  { title: 'The second question'}, { body: 'I want to ask you some more...'}, { user_id: User.first.id },
  { title: 'The third question'}, { body: 'Let`s fix all bugs man!'}, { user_id: User.first.id }])

answers = Answer.create([
  { body: 'Test answer'}, { question_id: questions[0].id }, { user_id: User.first.id },
  { body: 'Test answer'}, { question_id: questions[1].id }, { user_id: User.first.id },
  { body: 'Test answer'}, { question_id: questions[2].id }, { user_id: User.first.id }])

comments = Comment.create([
{ body: 'New comment' }, { commentable_type: 'Question' }, { commentable_id: questions[0].id }, { user_id: User.first.id },
{ body: 'New comment' }, { commentable_type: 'Answer' }, { commentable_id: answers[0].id }, { user_id: User.first.id },
{ body: 'New comment' }, { commentable_type: 'Question' }, { commentable_id: questions[2].id }, { user_id: User.first.id }])
