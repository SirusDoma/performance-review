# frozen_string_literal: true

module AssignmentService
  class Assignator < ApplicationService
    def initialize(authenticated_user, form)
      super(:assign, %i[assignment_service assignator])

      @user = Employee.find(authenticated_user.id)
      @form = form
    end

    def perform
      attributes = @form.attributes.merge(creator_id: @user.id)
      raise ResourceNotFoundError.new('Reviewer') unless Employee.exists?(attributes[:reviewer_id])
      raise ResourceNotFoundError.new('Reviewee') unless Employee.exists?(attributes[:reviewer_id])
      raise UnauthorizedError unless Employee.exists?(@user.id)

      if Assignment.pending.exists?(reviewer: assignment.reviewer, reviewee: assignment.reviewee)
        assignment = Assignment.new(attributes)
        assignment.errors.add(:reviewee, 'review is already in progress', reviewee_id: attributes[:reviewer_id])

        raise ActiveRecord::RecordInvalid.new(assignment)
      end

      Assignment.create!(attributes)
    end
  end
end
