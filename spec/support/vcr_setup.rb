require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<API_KEY>") { Rails.application.credentials.dig(:weather, :api_key) }
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes }
end
