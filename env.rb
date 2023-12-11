ENV["RACK_ENV"] ||= "development"

case ENV["RACK_ENV"]
when "development"
  require 'dotenv'
  Dotenv.load ".env"
when "test"
  require 'dotenv'
  Dotenv.load ".env.test"
end

$:.unshift File.expand_path('lib', File.dirname(__FILE__))
env = ENV['RACK_ENV']

require 'bundler'
Bundler.require :default, env.to_sym

ActiveRecord::Base.establish_connection ENV['DATABASE_URL']

require 'web_store'
