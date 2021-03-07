# frozen_string_literal: true

class InvalidParameterError < ApplicationError
  def initialize(msg = nil)
    super(msg)
  end
end
