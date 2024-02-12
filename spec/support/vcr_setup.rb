require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true
  config.filter_sensitive_data('<AIR_QUALITY_HISTORY_API>') { ENV['AIR_QUALITY_HISTORY_API'] }
  config.filter_sensitive_data('<OPEN_WEATHER_MAP_API_KEY>') { ENV['OPEN_WEATHER_MAP_API_KEY'] }
end
