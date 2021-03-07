# frozen_string_literal: true

RSpec.describe ReviewController, type: :controller do
  subject { OpenStruct.new do_request(params).last }

  let(:actor)         { build_stubbed(:employee) }
  let(:assignment)    { build_stubbed(:assignment, :with_reviews) }
  let(:assignment_id) { assignment.id }

  resource 'Reviews' do
    explanation I18n.t('documentation.reviews.explanation')

    post '/assignments/:assignment_id/reviews', route: 'Review Resource', action: 'Create reviews' do
      include_context 'with authenticated_user'

      route_summary  I18n.t('documentation.reviews.resource.summary')
      action_summary I18n.t('documentation.reviews.resource.post')

      parameter :assignment_id, 'The id of assignment that will be done', required: true, type: :integer

      let(:expected_response) do
        {
          data: assignment.reviews.map(&:serializable_hash),
          meta: {
            offset: 0,
            limit:  assignment.reviews.length,
            total:  assignment.reviews.length
          }
        }
      end

      context 'with valid review answers' do
        include_context 'with authenticated_user'

        before do
          allow(ReviewService).to receive(:review).and_return(assignment)
        end

        let(:params) do
          {
            answers: [
              {
                question_id: 1,
                answer:      assignment.reviews.first.answer
              },
              {
                question_id: 2,
                answer:      assignment.reviews.second.answer
              }
            ]
          }
        end

        it 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end

      context 'with invalid answer' do
        let(:params) do
          {
            answers: [
              {
                question_id: 1,
                answer:      assignment.reviews.first.answer
              },
              {
                foo:  'bar',
                fizz: 'buzz'
              }
            ]
          }
        end

        it 'bad request' do
          expect(subject.response_status).to eq(400)
        end
      end
    end

    get '/assignments/:assignment_id/reviews', route: 'Review Resource', action: 'Get reviews' do
      include_context 'with authenticated_user'
      action_summary I18n.t('documentation.reviews.resource.get')

      context 'when requested' do
        before do
          allow(ReviewService).to receive(:fetch).and_return(assignment.reviews)
        end

        parameter :offset, I18n.t('documentation.parameter.offset'), required: false, type: :integer, default: 0
        parameter :limit,  I18n.t('documentation.parameter.limit'),  required: false, type: :integer, default: 10

        let(:expected_response) do
          {
            data: assignment.reviews,
            meta: {
              offset: 0,
              limit:  10,
              total:  assignment.reviews.length
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
