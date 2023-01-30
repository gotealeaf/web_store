require_relative './env'

# https://stackoverflow.com/a/43873756/617243
class ConnectionManagement
  def initialize(app)
    @app = app
  end

  def call(env)
    testing = env['rack.test']

    status, headers, body = @app.call(env)
    proxy = ::Rack::BodyProxy.new(body) do
      ActiveRecord::Base.clear_active_connections! unless testing
    end
    [status, headers, proxy]
  rescue Exception
    ActiveRecord::Base.clear_active_connections! unless testing
    raise
  end
end

use ConnectionManagement

use Rack::Static,
  :urls => ["/css", "/images", "/lib", "/swagger-ui.js"],
  :root => "public/swagger-ui",
  :index => 'index.html'

  require 'rack/cors'
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :patch, :put, :options]
    end
  end
  
  run Rack::Cascade.new [WebStore::API, WebStore::Web]
