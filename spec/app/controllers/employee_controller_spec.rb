# frozen_string_literal: true

RSpec.describe EmployeeController, type: :controller do
  subject { OpenStruct.new do_request(params).last }

  let(:actor)       { build_stubbed(:employee, :as_admin, password: password) }
  let(:employee)    { build_stubbed(:employee) }
  let(:employee_id) { employee&.id }
  let(:password)    { '123_s3cr3t_p4ssw0rd' }

  resource 'Employees' do
    explanation I18n.t('documentation.employees.explanation')

    let(:params) { EmployeeForm.new(employee).attributes }
    let(:expected_response) do
      {
        data: employee.serializable_hash
      }
    end

    post '/employees', route: 'Employee Resource', action: 'Create employee' do
      route_summary  I18n.t('documentation.employees.resource.summary')
      action_summary I18n.t('documentation.employees.resource.post')

      context 'with valid parameters' do
        include_context 'with authenticated_user'

        before do
          allow(EmployeeService).to receive(:register).and_return([employee, password])
        end

        example 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end

      context 'with invalid parameters' do
        include_context 'with authenticated_user'

        let(:params) { {} }

        example 'bad request' do
          expect(subject.response_status).to eq(400)
        end
      end
    end

    get '/employees', route: 'Employee Resource', action: 'Get employees' do
      action_summary I18n.t('documentation.employees.resource.get')

      context 'when requested' do
        include_context 'with authenticated_user'
        before do
          allow(EmployeeService).to receive(:fetch).and_return([[employee], 0, 10, 1])
        end

        parameter :offset, I18n.t('documentation.parameter.offset'), required: false, type: :integer, default: 0
        parameter :limit,  I18n.t('documentation.parameter.limit'),  required: false, type: :integer, default: 10

        let(:expected_response) do
          {
            data: [employee.serializable_hash],
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

    patch '/employees/:employee_id', route: 'Employee Detail', action: 'Update employee' do
      route_summary  I18n.t('documentation.employees.detail.summary')
      action_summary I18n.t('documentation.employees.detail.patch')

      parameter :employee_id, 'The id of employee that will be modified', required: true, type: :integer

      context 'with valid parameter' do
        include_context 'with authenticated_user'

        before do
          allow(EmployeeService).to receive(:update).and_return(employee)
        end

        example 'success' do
          expect(subject.response_status).to eq(200)
          expect(subject.response_body).to include_json(expected_response)
        end
      end
    end
  end
end
