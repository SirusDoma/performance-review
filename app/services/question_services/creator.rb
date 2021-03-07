# frozen_string_literal: true

module QuestionService
  class Creator < ApplicationService
    def initialize(description)
      super(:create, %i[question_service creator])

      @description = description.to_s.strip
    end

    def perform
      Question.create!(description: @description)
    end
  end
end
