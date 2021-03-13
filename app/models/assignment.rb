# frozen_string_literal: true

class Assignment < ApplicationRecord
  include ActiveModel::Serializers::JSON

  belongs_to :reviewer, class_name: 'Employee', foreign_key: 'reviewer_id', inverse_of: :assignments
  belongs_to :reviewee, class_name: 'Employee', foreign_key: 'reviewee_id'
  belongs_to :creator,  class_name: 'Employee', foreign_key: 'creator_id'
  has_many   :reviews

  scope :pending, -> { includes(:reviews).where(reviews: { id: nil }) }
  scope :active,  -> { includes(:reviews).where.not(reviews: { id: nil }) }

  validates :reviewer_id, :reviewee_id, :creator_id, presence: true

  def serializable_hash(options = nil)
    options ||= {}
    if options.delete(:strict).blank?
      options[:include] = (options[:include] || {}).merge({
        reviewer: { only: %i[id full_name department] },
        reviewee: { only: %i[id full_name department] },
        creator:  { only: %i[id full_name department] }
      })
    end

    super(options)
  end
end
