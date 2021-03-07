# frozen_string_literal: true

RSpec.describe AuthController, type: :controller do
  subject { OpenStruct.new do_request(params).last }

  let(:actor)    { build_stubbed(:employee) }
  let(:email)    { actor.email }
  let(:password) { 'sup3r_s3cr3t_p4ssword' }
  let(:token)    { '123abcfoobar' }

  let(:exp_time)         { DateTime.now + 1.day }
  let(:service_response) { [actor.attributes.merge(exp: exp_time), token] }
  let(:expected_response) do
    {
      data: service_response.first,
      meta: {
        token: token
      }
    }
  end

  resource 'Authentication' do
    explanation I18n.t('documentation.authentication.explanation')

    post '/authenticate', route: 'Authenticate User' do
      route_summary  I18n.t('documentation.authentication.authenticate.summary')
      action_summary I18n.t('documentation.authentication.authenticate.post')

      let(:params) do
        {
          email:    email,
          password: password
        }
      end

      context 'with valid credential' do
        before do
          allow(AuthService).to receive(:authenticate).with(email, password).and_return(service_response)
        end

        example 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end

      context 'with invalid credential' do
        before do
          allow(AuthService).to receive(:authenticate).with(email, password).and_raise(UnauthorizedError)
        end

        example 'unauthorized' do
          expect(subject.response_status).to eq(401)
        end
      end
    end

    patch '/change-password', route: 'Change password' do
      include_context 'with authenticated_user'
      route_summary  I18n.t('documentation.authentication.change_password.summary')
      action_summary I18n.t('documentation.authentication.change_password.patch')

      let(:new_password) { '4n0th3r_s3cr3t' }
      let(:params) do
        {
          password:     password,
          new_password: new_password
        }
      end

      context 'when given valid credential' do
        before do
          allow(AuthService).to receive(:change_password).with(actor.email, password, new_password).and_return(service_response)
        end

        example 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end

      context 'when given invalid credential' do
        before do
          allow(AuthService).to receive(:change_password).with(actor.email, password, new_password).and_raise(UnauthorizedError)
        end

        example 'unauthorized' do
          expect(subject.response_status).to eq(401)
          expect(subject.response_body).to include_json({ message: UnauthorizedError.new.message })
        end
      end
    end
  end
end
