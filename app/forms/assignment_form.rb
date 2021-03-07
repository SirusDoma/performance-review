# frozen_string_literal: true

class AssignmentForm < ApplicationForm
  attribute :reviewer_id, :reviewee_id

  validates :reviewer_id, :reviewee_id, presence: true
  validates :reviewer_id, :reviewee_id, numericality: { only_integer: true }
end
