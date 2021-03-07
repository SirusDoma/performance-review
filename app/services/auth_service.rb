# frozen_string_literal: true

module AuthService
  module_function

  def authenticate(*args)
    AuthService::Authenticator.perform(*args)
  end

  def change_password(*args)
    AuthService::PasswordChanger.perform(*args)
  end
end
