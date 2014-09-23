ENV['RACK_ENV'] ||= 'test'

require 'minitest/spec'
require 'minitest/autorun'
require 'byebug'

require_relative '../env'

include Rack::Test::Methods

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

def app
  WebStore::API
end

def response
  last_response
end

def response_json
  JSON.parse(response.body)
end

def assert_json_response payload
  assert_equal payload, response_json
end

def post_json path, data, headers={}
  post path, data.to_json, headers.merge("CONTENT_TYPE" => "application/json")
end

DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before do
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
end

def encode_basic_auth(username, password)
  "Basic " + Base64.encode64("#{username}:#{password}")
end

def auth(username, password)
  {'HTTP_AUTHORIZATION' => encode_basic_auth(username, password)}
end

I18n.enforce_available_locales = false
