# frozen_string_literal: true

# This file must be loaded after Dotenv.load to work with .env file
# otherwise database configuration is not loaded yet into environment and cannot be injected to database.yml

require 'active_record'
require 'sinatra/activerecord'
