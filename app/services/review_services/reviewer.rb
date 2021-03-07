# frozen_string_literal: true

module ReviewService
  class Reviewer < ApplicationService
    def initialize(authenticated_user, form)
      super(:review, %i[review_service reviewer])

      @user = Employee.find(authenticated_user.id)
      @form = form
    end

    def perform
      ActiveRecord::Base.transaction do
        assignment = Assignment.find(@form.assignment_id)
        raise ForbiddenError if assignment.reviewer_id != @user.id

        reviews = []
        @form.answers.each do |data|
          question = Question.find(data.question_id)
          review   = Review.new(assignment: assignment, question: question, answer: data.answer)

          assignment.errors.add(:questions, "#{question.id} is already answered", question_id: question.id) if Review.exists?(assignment: assignment, question: question)
          next if assignment.errors.present?

          reviews.push(review) if review.save!
        end

        raise ActiveRecord::RecordInvalid.new(assignment) if assignment.errors.present?

        assignment
      end
    end
  end
end
