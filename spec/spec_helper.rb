# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'sinatra'
require 'rack/test'

require 'factory_bot'
require 'faker'
require 'database_cleaner/active_record'
require 'webmock/rspec'

require 'rspec_api_documentation/dsl'
require 'rspec/json_expectations'

require 'pry'

require_relative '../main'
require_all 'spec/support'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods
  config.include RspecApiDocumentation
  config.include PerformanceReview::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  RspecApiDocumentation.configure do |config|
    config.format          = :api_blueprint
    config.api_name        = I18n.t('documentation.api_name')
    config.api_explanation = I18n.t('documentation.api_description')

    config.keep_source_order          = true
    config.request_headers_to_include = %w[Host Authorization Content-Type Accept]
    config.request_body_formatter     = proc { |params| JSON.pretty_generate(params) }
    config.response_body_formatter    = proc { |_, response_body| JSON.pretty_generate(JSON.parse(response_body)) }
  end

  config.before(:suite) do
    FactoryBot.find_definitions

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.start

    WebMock.disable_net_connect!
  end

  config.before do |spec|
    next if spec.metadata[:type] != :controller

    RspecApiDocumentation.configuration.app = described_class

    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'
  end

  config.after do
    DatabaseCleaner.clean
  end
end
