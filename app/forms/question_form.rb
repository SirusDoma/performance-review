# frozen_string_literal: true

class QuestionForm < ApplicationForm
  attribute :id, :description

  validates :id, presence: true, numericality: { only_integer: true }, on: %i[update delete]
  validates :description, presence: true, on: %i[create update]
end
