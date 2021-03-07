# frozen_string_literal: true

class QuestionController < ::PerformanceReview
  get '/questions' do
    authorize!

    data, offset, limit, total = QuestionService.fetch(params[:offset]&.to_i, params[:limit]&.to_i)
    response = ApplicationSerializer.serialize(data, offset: offset, limit: limit, total: total)

    [200, json(response)]
  end

  post '/questions' do
    authorize!(:exclusive)

    form = QuestionForm.new(params)
    form.validate!(:create)

    question = QuestionService.create(form.description)
    response = ApplicationSerializer.serialize(question)

    [200, json(response)]
  end

  patch '/questions/:id' do
    authorize!(:exclusive)

    form = QuestionForm.new(params)
    form.validate!(:update)

    question = QuestionService.update(form.id, form.description)
    response = ApplicationSerializer.serialize(question)

    [200, json(response)]
  end

  delete '/questions/:id' do
    authorize!(:exclusive)

    form = QuestionForm.new(params)
    form.validate!(:delete)

    question = QuestionService.delete(form.id)
    response = ApplicationSerializer.serialize(question)

    [200, json(response)]
  end
end
