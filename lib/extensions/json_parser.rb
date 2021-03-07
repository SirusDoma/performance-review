# frozen_string_literal: true

module Extension
  module JsonParser
    extend Sinatra::Extension

    before do
      break unless request.body&.string&.present?

      payload = JSON.parse(request.body.string, symbolize_names: true)
      params.merge!(payload)
    rescue JSON::ParserError
      raise InvalidParameterError, 'Malformed request body'
    end
  end
end
