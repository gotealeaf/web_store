require_relative './env'

use Rack::Static,
  :urls => ["/css", "/images", "/lib", "/swagger-ui.js"],
  :root => "public/swagger-ui",
  :index => 'index.html'

run WebStore::API
