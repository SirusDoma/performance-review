# frozen_string_literal: true

module Extension
  module ErrorHandler
    extend Sinatra::Extension
    helpers self

    not_found do
      [404, json({ message: 'Not found' })]
    end

    error ::ActiveModel::ValidationError do |err|
      [400, json({ message: err.message, errors: err.model&.errors&.details || [] })]
    end

    error ::ActiveRecord::RecordInvalid do |err|
      [400, json({ message: err.message, errors: err.record&.errors&.details || [] })]
    end

    error ::ActiveRecord::RecordNotFound, ResourceNotFoundError do |err|
      [404, json({ message: err.message })]
    end

    error ApplicationError do |err|
      [err.http_code || 500, json({ message: err.message })]
    end

    error do |err|
      [500, json({ message: err.message || 'Internal server error' })]
    end
  end
end
