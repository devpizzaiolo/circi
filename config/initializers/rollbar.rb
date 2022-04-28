require 'rollbar'

Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN'] if ENV['ROLLBAR_ACCESS_TOKEN'].present?
end