# frozen_string_literal: true

module Extension
  module Authenticator
    extend Sinatra::Extension
    helpers self

    before do
      _, token = request.get_header('HTTP_AUTHORIZATION')&.split || [nil, nil]
      break if token.nil?

      payload, = JWT.decode(token, settings.secret_key, true, { algorithm: 'HS256' })
      request.env['authenticated_user'] = Employee.new(payload.except('exp'))
    rescue JWT::ExpiredSignature
      raise UnauthorizedError, 'Token is expired'
    rescue JWT::DecodeError
      raise UnauthorizedError
    end

    def authenticated_user
      request.env['authenticated_user']
    end

    def authorize!(context = :public)
      return true if context == :guest
      raise UnauthorizedError unless authenticated_user.present?
      raise ForbiddenError if context == :exclusive && !authenticated_user.is_admin

      true
    end
  end
end
