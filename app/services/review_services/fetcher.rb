# frozen_string_literal: true

module ReviewService
  class Fetcher < ApplicationService
    def initialize(authenticated_user, assignment_id)
      super(:fetch, %i[review_service fetcher])

      @user          = Employee.find(authenticated_user.id)
      @assignment_id = assignment_id
    end

    def perform
      assignment = Assignment.find(@assignment_id)
      raise ForbiddenError unless assignment.reviewer_id == @user.id || @user.is_admin?

      assignment.reviews.to_a
    end
  end
end
