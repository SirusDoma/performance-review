# frozen_string_literal: true

RSpec.describe QuestionController, type: :controller do
  subject { OpenStruct.new do_request(params).last }

  let(:actor)       { build_stubbed(:employee, :as_admin) }
  let(:question)    { build_stubbed(:question) }
  let(:question_id) { question&.id }
  let(:description) { 'What did this person do well?' }

  resource 'Questions' do
    explanation I18n.t('documentation.questions.explanation')

    post '/questions', route: 'Question Resource', action: 'Create question' do
      route_summary  I18n.t('documentation.questions.resource.summary')
      action_summary I18n.t('documentation.questions.resource.post')

      let(:params) do
        {
          description: description
        }
      end
      let(:expected_response) do
        {
          data: question.serializable_hash
        }
      end

      context 'with valid description' do
        include_context 'with authenticated_user'

        before do
          allow(QuestionService).to receive(:create).and_return(question)
        end

        example 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end

      context 'with invalid description' do
        include_context 'with authenticated_user'

        let(:description) { nil }

        example 'bad request' do
          expect(subject.response_status).to eq(400)
        end
      end
    end

    get '/questions', route: 'Question Resource', action: 'Get questions' do
      action_summary I18n.t('documentation.questions.resource.get')

      context 'when requested' do
        include_context 'with authenticated_user'
        before do
          allow(QuestionService).to receive(:fetch).and_return([[question], 0, 10, 1])
        end

        parameter :offset, I18n.t('documentation.parameter.offset'), required: false, type: :integer, default: 0
        parameter :limit,  I18n.t('documentation.parameter.limit'),  required: false, type: :integer, default: 10

        let(:expected_response) do
          {
            data: [question.serializable_hash],
            meta: {
              offset: 0,
              limit:  10,
              total:  1
            }
          }
        end

        example 'success' do
          expect(subject.response_status).to eq(200)
        end
      end
    end

    patch '/questions/:question_id', route: 'Question Detail', action: 'Update question' do
      route_summary  I18n.t('documentation.questions.detail.summary')
      action_summary I18n.t('documentation.questions.detail.patch')

      parameter :question_id, 'The id of question that will be modified', required: true, type: :integer

      let(:params) do
        {
          description: description
        }
      end
      let(:expected_response) do
        {
          data: question.serializable_hash
        }
      end

      context 'with valid parameter' do
        include_context 'with authenticated_user'

        before do
          allow(QuestionService).to receive(:update).and_return(question)
        end

        example 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end
    end

    delete '/questions/:question_id', route: 'Question Detail', action: 'Delete question' do
      action_summary I18n.t('documentation.questions.detail.delete')

      parameter :question_id, 'The id of question that will be deleted', required: true, type: :integer

      let(:expected_response) do
        {
          data: question.serializable_hash
        }
      end

      context 'when requested' do
        include_context 'with authenticated_user'

        before do
          allow(QuestionService).to receive(:delete).and_return(question)
        end

        example 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end
    end
  end
end
