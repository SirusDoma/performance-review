# frozen_string_literal: true

class ResourceNotFoundError < ApplicationError
  def initialize(resource_name = nil)
    super(resource: resource_name || 'Resource')
  end
end
