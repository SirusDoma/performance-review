# frozen_string_literal: true

module AssignmentService
  module_function

  def fetch(*args)
    AssignmentService::Fetcher.perform(*args)
  end

  def assign(*args)
    AssignmentService::Assignator.perform(*args)
  end
end
