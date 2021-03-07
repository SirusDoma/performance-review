# frozen_string_literal: true

module QuestionService
  class Fetcher < ApplicationService
    def initialize(offset, limit)
      super(:fetch, %i[question_service fetcher])

      @offset   = offset || 0
      @limit    = limit  || 10
    end

    def perform
      result = Question.offset(@offset).limit(@limit)
      total  = Question.count

      [result, @offset, @limit, total]
    end
  end
end
