# frozen_string_literal: true

module EmployeeService
  class Fetcher < ApplicationService
    def initialize(offset, limit, criteria = {})
      super(:fetch, %i[employee_service fetcher])

      @offset   = offset || 0
      @limit    = limit  || 10
      @criteria = criteria.select { |_, val| val.present? } || {}
    end

    def perform
      if @criteria.present?
        query = Employee.where(@criteria)
        total = query.count
      else
        query = Employee
        total = Employee.count
      end

      result = query.offset(@offset).limit(@limit)
      [result, @offset, @limit, total]
    end
  end
end
