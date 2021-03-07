# frozen_string_literal: true

class ApplicationService
  class << self
    def perform(*args)
      start   = Time.now.to_f
      service = new(*args)
      result  = service.send(:perform)
      log(service, start: start)

      result
    rescue StandardError => e
      start   ||= Time.now.to_f
      service ||= nil
      log(service, start: start, error: e)

      raise e
    end

    private

    def log(service, options = {})
      options ||= {}
      latency = ((Time.now.to_f - (options[:start] || 0)) * 1000).round(5)
      entry = {
        action:   service&.action,
        tags:     service&.tags,
        duration: latency
      }

      error = options[:error]
      if error.present?
        entry[:error] = {
          message:   error.message,
          backtrace: error.backtrace.select { |trace| trace.include?('performance-review-api') }.join('\n')
        }

        PerformanceReview.logger.error(entry)
      else
        PerformanceReview.logger.info(entry)
      end
    end
  end

  attr_reader :action, :tags

  def initialize(action, tags)
    @action = action
    @tags   = tags
  end

  def perform
    raise NotImplementedError
  end
end
