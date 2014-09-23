module WebStore
  class API < Grape::API
    version 'v1', using: :path

    format :json
    default_format :json

    helpers do
      def declared_params
        declared(params, include_missing: false)
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      message = e.message.gsub(/\s*\[.*\Z/, '')
        Rack::Response.new(
          [{ status_code: 404, message: message }.to_json],
          404,
          { 'Content-Type' => 'application/json' }
        )
    end

    before do
      begin
        body = request.body.read
        JSON.parse body unless body.blank?
      rescue JSON::ParserError => e
        error!({status_code: 415, message: "POST, PUT, and PATCH requests must have application/json media type"}, 415)
      end
    end

    desc "Fetch all products."
    get '/products' do
      Product.all
    end

    desc "Fetch a single product."
    params do
      requires :id, type: Integer, desc: 'Product ID'
    end
    get '/products/:id' do
      Product.find params[:id]
    end


    group do
      http_basic do |username, password|
        { 'admin' => 'password' }[username] == password
      end

      desc "Create a new product."
      params do
        requires :name, type: String, desc: 'Name of the product'
        requires :sku, type: String, regexp: /[\w]{3,}/,
          desc: '3+ character unique identifier for product'
        optional :price, type: Integer, desc: 'Price of the product in cents'
      end
      post '/products' do
        product = Product.new declared_params
        if product.save
          product
        else
          status 422
          {status_code: 422, message: product.errors.full_messages.to_sentence}
        end
      end

      desc "Reset the store to its default state."
      post '/reset' do
        status 200

        Product.truncate_and_reset_table!
        Product.seed!

        { status_code: 200, message: "The web store has been reset!" }
      end
    end

    add_swagger_documentation api_version: "v1",
      hide_documentation_path: true,
      hide_format: true,
      info: {
        title: "Web Store API",
        description: "An example API server from Tealeaf."
      }

    route :any, '*path' do
      status 404
      { status_code: 404, message: "Path not found."}
    end
  end
end
