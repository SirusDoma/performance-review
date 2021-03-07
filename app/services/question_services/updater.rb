# frozen_string_literal: true

module QuestionService
  class Updater < ApplicationService
    def initialize(id, description)
      super(:update, %i[question_service updater])

      @id          = id.to_i
      @description = description.to_s.strip
    end

    def perform
      raise InvalidParameterError 'Answered question cannot be modified' if Review.exists?(question_id: @id)

      question = Question.find(@id)
      question.update!(description: @description)

      question
    end
  end
end
