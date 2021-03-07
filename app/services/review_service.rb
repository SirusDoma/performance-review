# frozen_string_literal: true

module ReviewService
  module_function

  def fetch(*args)
    ReviewService::Fetcher.perform(*args)
  end

  def review(*args)
    ReviewService::Reviewer.perform(*args)
  end
end
