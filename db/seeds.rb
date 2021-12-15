# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Test.destroy_all

user = User.find_or_initialize_by(email: 'teacher@example.com')
user.name = 'teacher of the year'
user.password = '12345678'
user.password_confirmation = '12345678'
user.role = :teacher
user.save!


user = User.find_or_initialize_by(email: 'student@example.com')
user.name = 'student'
user.password = '12345678'
user.password_confirmation = '12345678'
user.role = :student
user.save!


tests_subjects = %w[Computer Software Design]

tests_subjects.each do |ts|
  test = Test.create!(title: ts, description: "Test About #{ts}")
  3.times do |q|
    question = Question.create!(test_id: test.id, title: "Question #{q+1}", description: "Question #{ts} #{q+1}:")
    correct_answer = rand(4)
    ('A'..'D').each_with_index do |o, i|
      QuestionOption.create!(title: o, question_id: question.id, correct: i == correct_answer)
    end
  end
end
