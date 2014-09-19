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
