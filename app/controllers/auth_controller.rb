# frozen_string_literal: true

class AuthController < ::PerformanceReview
  post '/authenticate' do
    authorize!(:guest)

    payload, token = AuthService.authenticate(params[:email].to_s, params[:password].to_s)
    response = ApplicationSerializer.serialize(payload, token: token)

    [200, json(response)]
  end

  patch '/change-password' do
    authorize!

    payload, token = AuthService.change_password(authenticated_user.email, params[:password].to_s, params[:new_password].to_s)
    response = ApplicationSerializer.serialize(payload, token: token)

    [200, json(response)]
  end
end
