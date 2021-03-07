# frozen_string_literal: true

module AuthService
  class Authenticator < ApplicationService
    def initialize(email, password)
      super(:authenticate, %i[auth_service authentication])

      @email    = email
      @password = password
    end

    def perform
      employee = Employee.find_by(email: @email)&.authenticate(@password)
      raise UnauthorizedError unless employee.present?

      payload  = employee.attributes.merge(exp: (Time.now + 1.day).to_i)
      token    = JWT.encode(payload, ::PerformanceReview.settings.secret_key, 'HS256')

      [payload, token]
    end
  end
end
