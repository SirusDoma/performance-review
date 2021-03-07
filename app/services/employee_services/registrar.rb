# frozen_string_literal: true

module EmployeeService
  class Registrar < ApplicationService
    def initialize(form)
      super(:register, %i[employee_service registration])

      @form = form
    end

    def perform
      attributes = @form.attributes.merge(password: SecureRandom.hex(12).to_s)
      employee   = Employee.create!(attributes)

      [employee, attributes[:password]]
    end
  end
end
