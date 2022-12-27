module WebStore
  class Web < Sinatra::Base
    set :static, true
    set :public_folder, File.expand_path("../../../public", __FILE__)
    set :app_file, __FILE__
    set :erb, :escape_html => true
    set :method_override, true

    error ActiveRecord::RecordNotFound do |e|
      status 404
      e.message.gsub(/\s*\[.*\Z/, '')
    end

    def product_params
      params.slice("name", "price", "sku")
    end

    get "/products" do
      @products = Product.all
      erb :index, layout: !request.xhr?
    end

    get "/products/new" do
      @product = Product.new
      erb :new, layout: !request.xhr?
    end

    get "/products/:id" do |id|
      @product = Product.find(id)
      erb :show, layout: !request.xhr?
    end

    get "/products/:id/edit" do |id|
      @product = Product.find(id)
      erb :edit, layout: !request.xhr?
    end

    def require_user!
      unless request.env["HTTP_AUTHORIZATION"] == "token AUTH_TOKEN"
        status 401
        halt
      end
    end

    error 401 do
      "You must be logged in to do that."
    end

    post "/products" do
      require_user!
      @product = Product.new(product_params)
      if @product.save
        redirect "/products"
      else
        status 422
        erb :new, layout: !request.xhr?
      end
    end

    post "/products/:id" do |id|
      require_user!
      @product = Product.find(id)
      if @product.update_attributes(product_params)
        if request.xhr?
          erb :show, layout: false
        else
          redirect "/products"
        end
      else
        status 422
        erb :edit, layout: !request.xhr?
      end
    end

    delete "/products/:id" do |id|
      require_user!
      @product = Product.find(id)
      @product.destroy
      redirect "/products"
    end
  end
end
