source 'https://rubygems.org'

ruby '2.3.3'

gem 'dotenv', :groups => [:development, :test]

gem 'rack'
gem 'grape'
gem 'activerecord', require: 'active_record'
gem 'hashie-forbidden_attributes'

gem 'pg'
gem 'rake'
gem 'racksh'
gem 'grape-swagger'

group :development do
  gem 'byebug'
  gem 'rerun'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rack-test', require: 'rack/test'
  gem 'database_cleaner'
end

group :production do
  gem 'unicorn'
end
