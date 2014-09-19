begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  # Don't load dotenv in production
end

$:.unshift File.expand_path('lib', File.dirname(__FILE__))
env = (ENV['RACK_ENV'] || :development)

require 'bundler'
Bundler.require :default, env.to_sym

ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.establish_connection ENV['DATABASE_URL']

require 'web_store'
