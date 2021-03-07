# frozen_string_literal: true

RSpec.describe AssignmentController, type: :controller do
  subject { OpenStruct.new do_request(params).last }

  let(:actor)         { build_stubbed(:employee, :as_admin) }
  let(:assignment)    { build_stubbed(:assignment, creator: actor) }
  let(:assignment_id) { assignment&.id }
  let(:reviewer)      { assignment&.reviewer }
  let(:reviewee)      { assignment&.reviewee }

  resource 'Assignments' do
    explanation I18n.t('documentation.assignments.explanation')

    post '/assignments', route: 'Assignment Resource', action: 'Create assignment' do
      include_context 'with authenticated_user'

      route_summary  I18n.t('documentation.assignments.resource.summary')
      action_summary I18n.t('documentation.assignments.resource.post')

      let(:params) do
        {
          reviewer_id: reviewer.id,
          reviewee_id: reviewee.id
        }
      end
      let(:expected_response) do
        {
          data: assignment.serializable_hash
        }
      end

      context 'with valid reviewer and reviewee' do
        include_context 'with authenticated_user'

        before do
          allow(AssignmentService).to receive(:assign).and_return(assignment)
        end

        it 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end

      context 'with invalid reviewer' do
        before do
          allow(AssignmentService).to receive(:assign).and_raise(ResourceNotFoundError.new('Reviewer'))
        end

        it 'reviewer not found' do
          expect(subject.response_status).to eq(404)
        end
      end

      context 'with invalid reviewee' do
        before do
          allow(AssignmentService).to receive(:assign).and_raise(ResourceNotFoundError.new('Reviewee'))
        end

        it 'reviewee not found' do
          expect(subject.response_status).to eq(404)
        end
      end
    end

    get '/assignments', route: 'Assignment Resource', action: 'Get assignments' do
      include_context 'with authenticated_user'
      action_summary I18n.t('documentation.assignments.resource.get')

      context 'when requested' do
        before do
          allow(AssignmentService).to receive(:fetch).and_return([[assignment], 0, 10, 1])
        end

        parameter :offset, I18n.t('documentation.parameter.offset'), required: false, type: :integer, default: 0
        parameter :limit,  I18n.t('documentation.parameter.limit'),  required: false, type: :integer, default: 10

        let(:expected_response) do
          {
            data: [assignment.serializable_hash],
            meta: {
              offset: 0,
              limit:  10,
              total:  1
            }
          }
        end

        it 'success' do
          expect(subject.response_status).to eq(200)
        end
      end
    end
  end
end
