require_relative './env'

require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put, :options]
  end
end

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run Rack::Cascade.new [WebStore::API, WebStore::Web]
