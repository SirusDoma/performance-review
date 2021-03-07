# frozen_string_literal: true

module EmployeeService
  class Updater < ApplicationService
    def initialize(form)
      super(:update, %i[employee_service updater])

      @form = form
    end

    def perform
      attributes = @form.attributes
      employee   = Employee.find(attributes[:id])
      employee.update!(attributes)

      employee
    end
  end
end
