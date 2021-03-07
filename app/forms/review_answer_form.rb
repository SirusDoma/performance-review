# frozen_string_literal: true

class ReviewAnswerForm < ApplicationForm
  attribute :question_id, :answer

  validates :question_id, presence: true, numericality: { only_integer: true }
  validates :answer, presence: true
end
