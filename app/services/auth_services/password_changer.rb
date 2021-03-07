# frozen_string_literal: true

module AuthService
  class PasswordChanger < ApplicationService
    def initialize(email, password, new_password)
      super(:change_password, %i[auth_service password_changer])

      @email        = email
      @password     = password
      @new_password = new_password
    end

    def perform
      employee = Employee.find_by(email: @email)&.authenticate(@password)
      raise UnauthorizedError unless employee.present?

      employee.password = @new_password
      employee.save!
    end
  end
end
