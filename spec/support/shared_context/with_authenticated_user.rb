# frozen_string_literal: true

RSpec.shared_context 'with authenticated_user' do
  let(:access_token) { '123_sup3r_s3cr3t_t0k3n' }
  let(:secret_key)   { PerformanceReview.settings.secret_key }

  before do
    header('Authorization', "Bearer #{access_token}")

    payload = actor || build_stubbed(:employee)
    allow(JWT).to receive(:decode).with(access_token, secret_key, true, { algorithm: 'HS256' }).and_return([payload.attributes, nil])
  end
end
