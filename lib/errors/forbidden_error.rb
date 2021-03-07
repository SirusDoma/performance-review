# frozen_string_literal: true

class ForbiddenError < ApplicationError
  def initialize(msg = nil)
    super(msg)
  end
end
