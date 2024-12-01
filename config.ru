require_relative './env'

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

class Router
  def initialize(api_app, web_app)
    @api = api_app
    @web = Rack::Static.new(web_app, {
      :urls => ["/css", "/images", "/lib", "/swagger-ui.js"],
      :root => "public/swagger-ui",
      :index => 'index.html'
    })
  end

  def call(env)
    if env['PATH_INFO'].start_with?('/v1')
      @api.call(env)
    else
      @web.call(env)
    end
  end
end

use ConnectionManagement
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put, :options]
  end
end

run Router.new(WebStore::API, WebStore::Web)