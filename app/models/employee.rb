# frozen_string_literal: true

class Employee < ApplicationRecord
  include ActiveModel::Serializers::JSON
  form EmployeeForm

  has_many :assignments, inverse_of: :reviewer, foreign_key: :reviewer_id
  has_secure_password

  validates :full_name, :gender, :department, :phone_number, :address, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  enum gender: %i[male female]

  def attributes
    super.except('password_digest')
  end
end
