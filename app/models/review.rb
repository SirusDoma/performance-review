# frozen_string_literal: true

class Review < ApplicationRecord
  include ActiveModel::Serializers::JSON

  belongs_to :assignment
  belongs_to :question, -> { unscope(where: :deleted_at) }

  validates :assignment_id, :question_id, presence: true

  def serializable_hash(options = nil)
    options ||= {}
    if options.blank?
      options[:except]  = %i[question_id]
      options[:include] = {
        question: { only: %i[id description] }
      }
    end

    super
  end
end
