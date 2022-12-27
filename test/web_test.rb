require 'test_helper'

module WebStore
  describe Web do

    def app
      WebStore::Web
    end

    before do
      Product.destroy_all
    end

    it "views product index" do
      Product.create! name: "Red Pen", sku: "redp100", price: 100
      Product.create! name: "Blue Pen", sku: "blup100", price: 100
      Product.create! name: "Black Pen", sku: "blap100", price: 100

      get '/products'

      assert_equal 200, response.status

      assert_match "Red Pen", response.body
      assert_match "Blue Pen", response.body
      assert_match "Black Pen", response.body
    end

    it "views a single product" do
      product = Product.create! name: "Red Pen", sku: "redp100", price: 100

      get "/products/#{product.id}"

      assert_equal 200, response.status
      assert_match "Red Pen", response.body
    end

    it "returns 404 when a product is not found" do
      get "/products/1000000"

      assert_equal 404, response.status
      assert_match "Couldn't find WebStore::Product with 'id'=1000000", response.body
    end

    #it "requires authentication to create a new product" do
      #post '/products', {name: 'Green Pen', sku: 'grep100', price: 100}

      #assert_equal 401, response.status
      ## assert error displayed in page
    #end

    it "creates a new product" do
      header "Authorization", "token AUTH_TOKEN"
      post '/products',
        {name: 'Green Pen', sku: 'grep100', price: 100}

      assert_equal 302, response.status

      get "/products"

      assert_match "Green Pen", response.body
      assert_match "$1.00", response.body
    end

    it "requires a name to create a product" do
      header "Authorization", "token AUTH_TOKEN"
      post '/products',
        {name: '', sku: 'grep100', price: 100}

      assert_equal 422, response.status
      assert_match "Name can't be blank", response.body
    end

    it "requires a unique sku to create a product" do
      header "Authorization", "token AUTH_TOKEN"
      Product.create! name: 'Greenish Pen', sku: 'grep100', price: 100

      post '/products',
        {name: 'Green Pen', sku: 'grep100', price: 100}

      assert_equal 422, response.status
      assert_match "Sku has already been taken!", response.body
    end

    it "requires a price to create a product" do
      header "Authorization", "token AUTH_TOKEN"
      post '/products',
        {name: 'Green Pen', sku: 'grep100'}

      assert_equal 422, response.status
      assert_match "Price must be an integer greater than 0!", response.body
    end

    it "updates an existing product" do
      product = Product.create! name: "Magic Pen", sku: "magp100", price: 500

      header "Authorization", "token AUTH_TOKEN"
      post "/products/#{product.id}",
        {name: 'Green Pen', sku: 'grep100', price: 100}

      assert_equal 302, response.status
      get "/products/#{product.id}"

      assert_match "Green Pen", response.body
    end

    it "requires authentication to update a product" do
      product = Product.create! name: "Magic Pen", sku: "magp100", price: 500

      post "/products/#{product.id}",
        {name: 'Green Pen', sku: 'grep100', price: 100}

      assert_equal 401, response.status

      assert_equal 1, Product.where(sku: "magp100").count
    end

    it "deletes a existing product" do
      product = Product.create! name: "Magic Pen", sku: "magp100", price: 500

      header "Authorization", "token AUTH_TOKEN"
      delete "/products/#{product.id}"

      assert_equal 302, response.status

      get "/products"
      refute_match "Magic Pen", response.body
    end

    it "requires authentication to delete a product" do
      product = Product.create! name: "Magic Pen", sku: "magp100", price: 500

      delete "/products/#{product.id}"

      assert_equal 401, response.status
      assert_equal 1, Product.count

      assert_equal 1, Product.where(sku: "magp100").count
    end

    #it "deletes all products and seeds with default data" do
      #Product.create! name: "Magic Pen", sku: "magp100", price: 50000

      #post '/v1/reset', {}, auth('admin', 'password')

      #assert_equal 200, response.status
      #assert_json_response(
        #"status_code" => 200,
        #"message" => "The web store has been reset!"
      #)

      #assert_equal 3, Product.count

      #assert_equal 0, Product.where(sku: "magp100").count
    #end

    #it "requires authentication to reset products" do
      #Product.create! name: "Magic Pen", sku: "magp100", price: 50000

      #post '/v1/reset'

      #assert_equal 401, response.status
      #assert_equal 1, Product.count

      #assert_equal 1, Product.where(sku: "magp100").count
    #end
  end
end
