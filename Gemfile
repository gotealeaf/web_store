source 'https://rubygems.org'

ruby '3.1.3'

gem 'dotenv', '0.11.1', :groups => [:development, :test]

gem 'rack', '1.6.13'
gem 'grape'
gem 'sinatra'
gem 'erubi'

gem 'activerecord', require: 'active_record'
gem 'hashie-forbidden_attributes'
gem 'rack-cors', :require => 'rack/cors'

gem 'pg'
gem 'rake', '10.3.2'
gem 'racksh', '1.0.0'
gem 'grape-swagger', '0.31.1'

group :development do
  gem 'byebug'
  gem 'rerun'
  gem 'shotgun'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rack-test', require: 'rack/test'
  gem 'database_cleaner'
end

group :production do
  gem 'unicorn', '4.8.3'
end
