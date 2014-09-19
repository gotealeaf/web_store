# A sample Gemfile
source 'https://rubygems.org'

ruby '2.1.2'

gem 'dotenv', :groups => [:development, :test]

gem 'rack', '~> 1.5.2'
gem 'grape', '~> 0.5.0'
gem 'activerecord', require: 'active_record'
gem 'pg'
gem 'rake'
gem 'roar'
gem 'racksh'

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
