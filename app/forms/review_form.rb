# frozen_string_literal: true

class ReviewForm < ApplicationForm
  attribute :assignment_id, :answers, :question_id, :answer

  validates :assignment_id, presence: true, numericality: { only_integer: true }
  validates :answers, presence: true, on: :create

  def valid?(context = nil)
    super(context)

    details = []
    answers&.each do |answer|
      detail = []
      detail = answer.errors.map { |error| { error.attribute => { error: error.type } } } unless answer.valid?(context)
      details.push(detail)
    end

    errors.add(:answers, :invalid, details: details) if details.any?(&:present?)
    errors.empty?
  end
end
