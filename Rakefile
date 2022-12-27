require 'rake/testtask'

task :env do
  require_relative 'env'
end

desc "Setup the datebase"
task :setup_db => :env do
  require 'web_store/migration/create_products'
  WebStore::Migration::CreateProducts.migrate :up

  WebStore::Product.truncate_and_reset_table!
  WebStore::Product.seed!
end

desc "Setup the datebase"
task :reset_db => :env do
  WebStore::Product.truncate_and_reset_table!
  WebStore::Product.seed!
end

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
  t.libs << 'test'
  t.warning = false
end

task :default => :test
