# frozen_string_literal: true

class AssignmentController < ::PerformanceReview
  get '/assignments' do
    authorize!

    data, offset, limit, total = AssignmentService.fetch(authenticated_user, params[:offset]&.to_i, params[:limit]&.to_i)
    response = ApplicationSerializer.serialize(data, offset: offset, limit: limit, total: total)

    [200, json(response)]
  end

  post '/assignments' do
    authorize!(:exclusive)

    form = AssignmentForm.new(params)
    form.validate!

    assignment = AssignmentService.assign(authenticated_user, form)
    response = ApplicationSerializer.serialize(assignment)

    [200, json(response)]
  end
end
