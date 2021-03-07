# frozen_string_literal: true

# Ensure puma configuration loaded
require 'dotenv'
Dotenv.load

min_threads   = (ENV['PUMA_MIN_THREADS'] || 2).to_i
max_threads   = (ENV['PUMA_MAX_THREADS'] || 2).to_i
workers_count = (ENV['PUMA_WORKERS']     || 1).to_i

threads min_threads, max_threads
workers workers_count

port 8000
