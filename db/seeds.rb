# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'admin@qna.com', password: 'password', admin: true, confirmed_at: Time.now)

Question.create(title: 'The first question', body: 'I want to ask you some...',  user_id: User.first.id)
Question.create(title: 'The second question', body: 'I want to ask you some more...', user_id: User.first.id)

Answer.create(body: 'Test 1 answer', question_id: Question.first.id, user_id: User.first.id)
Answer.create(body: 'Test 2 answer', question_id: Question.last.id, user_id: User.first.id)

Comment.create(body: 'New 1 comment', commentable_type: 'Question', commentable_id: Question.first.id, user_id: User.first.id)
Comment.create(body: 'New 2 comment', commentable_type: 'Question', commentable_id: Question.last.id, user_id: User.first.id)
Comment.create(body: 'New 3 comment', commentable_type: 'Answer', commentable_id: Answer.first.id, user_id: User.first.id)
Comment.create(body: 'New 4 comment', commentable_type: 'Answer', commentable_id: Answer.last.id, user_id: User.first.id)

