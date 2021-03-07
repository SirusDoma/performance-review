# frozen_string_literal: true

module Extension
  module RequestTracer
    extend Sinatra::Extension
    helpers self

    before { request.env['requested_at'] = Time.now }

    after do
      next if settings.test?

      latency = ((Time.now.to_f - requested_at.to_f) * 1000).round(5)
      entry   = {
        action:          'request',
        actor_id:        authenticated_user&.id,
        status:          'success',
        response_status: response.status,
        tags:            request.env['sinatra.route']&.split || [],
        duration:        latency,
        request_uri:     request.env['PATH_INFO']
      }

      exception      = request.env['sinatra.error']
      entry[:params] = params unless settings.production?

      if exception.present?
        settings.logger.error(entry.merge({
          status:    'fail',
          tags:      entry[:tags] + ['error'],
          backtrace: exception.backtrace.slice(0, 30).select { |l| l.include?('performance-review-api/app') || l.include?('performance-review-api/lib') }.join("\n")
        }))
      else
        settings.logger.info(entry)
      end
    end

    def requested_at
      request.env['requested_at']
    end
  end
end
