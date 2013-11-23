# Load the Rails application.
require File.expand_path('../application', __FILE__)

GNIP_USERNAME = ENV['GNIP_USERNAME']
GNIP_PASSWORD = ENV['GNIP_PASSWORD']
GNIP_ACCOUNT = ENV['GNIP_ACCOUNT']
GNIP_STREAM_NAME = ENV['GNIP_STREAM_NAME']

# Initialize the Rails application.
GnipSearchDemo::Application.initialize!
