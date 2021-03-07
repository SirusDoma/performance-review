# frozen_string_literal: true

require 'sinatra/activerecord/rake'
require_relative 'main'

task 'docs:generate' do
  sh 'bundle exec rspec ./spec/app/controllers/ --format RspecApiDocumentation::ApiFormatter'
  sh 'npm install' unless File.file?("#{Dir.pwd}/node_modules/.bin/aglio")

  $stderr.reopen(File.new('/dev/null', 'w'))
  $stdout.reopen(File.new('/dev/null', 'w'))

  sh '$(npm bin)/aglio -i ./doc/api/index.apib --theme-variables slate -o ./doc/index.html' # --theme-full-width 
end
