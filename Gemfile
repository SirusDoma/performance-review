# frozen_string_literal: true

source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-activerecord'
gem 'sinatra-contrib', require: false

gem 'bcrypt'
gem 'dotenv'
gem 'faker'
gem 'i18n'
gem 'jwt'
gem 'puma'
gem 'rake'
gem 'require_all'

gem 'activerecord'
gem 'mysql2'

group :development, :test do
  gem 'pry'
  gem 'racksh'

  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
end

group :test do
  gem 'rspec'

  gem 'factory_bot'
  gem 'rack-test'
  gem 'webmock'
  
  gem 'rspec_api_documentation', git: 'https://github.com/SirusDoma/rspec_api_documentation'
  gem 'rspec-json_expectations', git: 'https://github.com/sherin/rspec-json_expectations.git'

  gem 'database_cleaner-active_record', require: false
end
