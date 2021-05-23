# frozen_string_literal: true

module EmployeeService
  class Fetcher < ApplicationService
    def initialize(offset, limit, criteria = {})
      super(:fetch, %i[employee_service fetcher])

      @offset   = offset || 0
      @limit    = limit  || 10
      @criteria = criteria.select { |_, val| val.present? }.symbolize_keys || {}
    end

    def perform
      query = Employee
      @criteria.each do |key, val|
        if Employee.type_for_attribute(key).type == :string
          query = query.where(Employee.arel_table[key].matches("%#{val}%"))
        else
          query = query.where(Hash[key, val])
        end
      end

      total  = query.count
      result = query.offset(@offset).limit(@limit)

      [result, @offset, @limit, total]
    end
  end
end
