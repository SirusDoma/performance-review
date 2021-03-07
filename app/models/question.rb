# frozen_string_literal: true

class Question < ApplicationRecord
  include ActiveModel::Serializers::JSON

  default_scope -> { where(deleted_at: nil) }

  validates :description, presence: true
end
