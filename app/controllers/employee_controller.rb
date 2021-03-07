# frozen_string_literal: true

class EmployeeController < ::PerformanceReview
  get '/employees' do
    authorize!(:exclusive)

    form = EmployeeForm.new(params)

    data, offset, limit, total = EmployeeService.fetch(params[:offset]&.to_i, params[:limit]&.to_i, form.attributes)
    response = ApplicationSerializer.serialize(data, offset: offset, limit: limit, total: total)

    [200, json(response)]
  end

  post '/employees' do
    authorize!(:exclusive)

    form = EmployeeForm.new(params)
    form.validate!

    employee, password = EmployeeService.register(form)
    response = ApplicationSerializer.serialize(employee, password: password)

    [200, json(response)]
  end

  patch '/employees/:id' do
    authorize!(:exclusive)

    form = EmployeeForm.new(params)
    form.validate!(:update)

    employee = EmployeeService.update(form)
    response = ApplicationSerializer.serialize(employee)

    [200, json(response)]
  end
end
