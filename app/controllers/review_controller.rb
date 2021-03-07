# frozen_string_literal: true

class ReviewController < ::PerformanceReview
  get '/assignments/:assignment_id/reviews' do
    authorize!

    form = ReviewForm.new(params)
    form.validate!(:index)

    reviews  = ReviewService.fetch(authenticated_user, form.assignment_id)
    response = ApplicationSerializer.serialize(reviews)

    [200, json(response)]
  end

  post '/assignments/:assignment_id/reviews' do
    authorize!

    input   = params.except(:answers)
    answers = params[:answers]&.map { |answer| ReviewAnswerForm.new(answer) } if params[:answers].is_a?(Array)
    answers ||= []

    form = ReviewForm.new(input.merge(answers: answers))
    form.validate!(:create)

    assignment = ReviewService.review(authenticated_user, form)
    response   = ApplicationSerializer.serialize(assignment.reviews.to_a, total: assignment.reviews.length)

    [200, json(response)]
  end
end
