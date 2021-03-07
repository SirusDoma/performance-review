# frozen_string_literal: true

class UnauthorizedError < ApplicationError
  def initialize(msg = nil)
    super(msg)
  end
end
