# frozen_string_literal: true

module QuestionService
  class Deleter < ApplicationService
    def initialize(id)
      super(:create, %i[question_service creator])

      @id = id.to_i
    end

    def perform
      question = Question.find(@id)
      question.delete!

      question
    end
  end
end
