ENV['RAILS_ENV'] = 'test'
ENV['GNIP_ACCOUNT']='account'
ENV['GNIP_STREAM_NAME']='search'
ENV['GNIP_USERNAME']='username'
ENV['GNIP_PASSWORD']='password'

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

require 'bundler/setup'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'pry'
require 'webmock'

RSpec.configure do |config|
  config.order = 'random'
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
