require_relative './env'

require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :patch, :options]
  end
end

use Rack::Static,
  :urls => ["swagger-ui"],
  :root => "public/swagger-ui",
  :index => 'index.html'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run WebStore::API
