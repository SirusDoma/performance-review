# frozen_string_literal: true

module QuestionService
  module_function

  def fetch(*args)
    QuestionService::Fetcher.perform(*args)
  end

  def create(*args)
    QuestionService::Creator.perform(*args)
  end

  def update(*args)
    QuestionService::Updater.perform(*args)
  end

  def delete(*args)
    QuestionService::Deleter.perform(*args)
  end
end
