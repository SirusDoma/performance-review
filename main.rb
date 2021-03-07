# frozen_string_literal: true

require 'require_all'

require 'sinatra'
require 'sinatra/extension'
require 'sinatra/json'

require 'dotenv'
require 'jwt'

# Load configuration
Dotenv.load

# Initializers for application and external components
require_all 'config/initializers'
require_all 'lib'

# Load application
require './app/performance_review'

# Load API Controllers
require_all 'app/controllers'
