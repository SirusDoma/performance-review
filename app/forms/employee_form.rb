# frozen_string_literal: true

class EmployeeForm < ApplicationForm
  attribute :id, :full_name, :email, :gender, :department, :phone_number, :address

  validates :id, presence: true, numericality: { only_integer: true }, on: :update
  validates :gender, inclusion: { in: %w[male female], message: 'is neither male or female' }, allow_nil: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
end
