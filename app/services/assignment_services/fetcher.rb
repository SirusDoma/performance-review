# frozen_string_literal: true

module AssignmentService
  class Fetcher < ApplicationService
    def initialize(authenticated_user, offset, limit)
      super(:fetch, %i[assignment_service fetcher])

      @user     = authenticated_user
      @offset   = offset || 0
      @limit    = limit  || 10
    end

    def perform
      if @user.is_admin?
        query = Assignment
        total = Assignment.count
      else
        query = Assignment.find_by(reviewer: @user)
        total = query.count
      end

      result = query.offset(@offset).limit(@limit)
      [result, @offset, @limit, total]
    end
  end
end
