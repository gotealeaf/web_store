require_relative './env'

use Rack::Static,
  :urls => ["/css", "/images", "/lib", "/swagger-ui.js"],
  :root => "public/swagger-ui",
  :index => 'index.html'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run WebStore::API
