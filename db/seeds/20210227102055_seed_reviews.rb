# frozen_string_literal: true

Assignment.all.each do |assignment|
  Question.all.each do |question|
    Review.create!(assignment: assignment, question: question, answer: Faker::Lorem.paragraphs(number: 2))
  end
end
