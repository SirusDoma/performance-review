# frozen_string_literal: true

require_all 'app/forms'
require_all 'app/models'
require_all 'app/services'
require_all 'app/serializers'

class PerformanceReview < Sinatra::Application
  # Configure default application settings
  configure do
    set     protection: { except: :json_csrf }
    disable :logging,
            :show_exceptions,
            :raise_errors,
            :dump_errors

    set secret_key: ENV.fetch('APP_KEY', '')
    set locale:     ENV.fetch('APP_LOCALE', 'en').to_sym

    set logger: Logger.new($stdout, level: Logger::INFO, formatter: proc { |s, t, prog, msg|
      prog ||= name
      next "#{s}, [#{t}] -- #{prog}: #{msg}\n" unless msg.is_a?(Hash)

      "#{JSON.dump(timestamp: t, level: s, message: msg)}\n"
    })
  end

  # Configure development / test settings
  configure :development, :test do
    enable :raise_errors,
           :dump_errors

    settings.logger.level = test? ? Logger::FATAL : Logger::DEBUG
  end

  # Configure external components settings
  configure do
    ActiveRecord::Base.logger = settings.logger
    I18n.locale               = settings.locale
  end

  # Configure extensions
  register ::Extension::ErrorHandler
  register ::Extension::JsonParser
  register ::Extension::Authenticator
  register ::Extension::RequestTracer
end
