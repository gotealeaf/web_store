require 'test_helper'

module WebStore
  describe API do

    before do
      Product.destroy_all
    end

    it "returns a list of products" do
      Product.create! name: "Red Pen", sku: "redp100", price: 100
      Product.create! name: "Blue Pen", sku: "blup100", price: 100
      Product.create! name: "Black Pen", sku: "blap100", price: 100

      get '/v1/products'

      assert_equal 200, response.status

      assert_json_response [
        {"id" => 1, "name" => "Red Pen", "sku" => "redp100", "price" => 100},
        {"id" => 2, "name" => "Blue Pen", "sku" => "blup100", "price" => 100},
        {"id" => 3, "name" => "Black Pen", "sku" => "blap100", "price" => 100}
      ]
    end

    it "returns a single product" do
      product = Product.create! name: "Red Pen", sku: "redp100", price: 100

      get "/v1/products/#{product.id}"

      assert_equal 200, response.status
      assert_json_response(
        {"id"=>1, "name"=>"Red Pen", "sku"=>"redp100", "price"=>100},
      )
    end

    it "returns 404 when a product is not found" do
      get "/v1/products/1000000"

      assert_equal 404, response.status
      assert_equal "application/json", response.headers['Content-Type']
      assert_json_response(
        "status_code" => 404,
        "message" => "Couldn't find WebStore::Product with 'id'=1000000"
      )
    end

    it "requires authentication to create a new product" do
      post_json '/v1/products', {name: 'Green Pen', sku: 'grep100', price: 100}

      assert_equal 401, response.status
    end

    it "requires json media type to create a new product" do
      post '/v1/products',
        {name: 'Green Pen', sku: 'grep100', price: 100}, auth('admin', 'password')

      assert_equal 415, response.status
      assert_json_response(
        "status_code" => 415, "message" => "POST, PUT, and PATCH requests must have application/json media type"
      )
    end

    it "creates a new product" do
      post_json '/v1/products',
        {name: 'Green Pen', sku: 'grep100', price: 100}, auth('admin', 'password')

      assert_equal 201, response.status
      assert_json_response(
        {"id" => 1, "name" => "Green Pen", "sku" => "grep100", "price" => 100},
      )
    end

    it "requires a name to create a product" do
      post_json '/v1/products',
        {name: '', sku: 'grep100', price: 100}, auth('admin', 'password')

      assert_equal 422, response.status
      assert_json_response(
        {"status_code"=>422, "message"=>"Name can't be blank"}
      )
    end

    it "requires a unique sku to create a product" do
      Product.create! name: 'Greenish Pen', sku: 'grep100', price: 100

      post_json '/v1/products',
        {name: 'Green Pen', sku: 'grep100', price: 100}, auth('admin', 'password')

      assert_equal 422, response.status
      assert_json_response(
        {"status_code"=>422, "message"=>"Sku has already been taken"}
      )
    end

    it "returns 404 with json for a nonexistent route" do
      get "/v1/foo/bar"

      assert_equal 404, response.status
      assert_equal "application/json", response.headers['Content-Type']
      assert_json_response(
        "status_code" => 404, "message" => "Path not found."
      )
    end

    it "deletes all products and seeds with default data" do
      Product.create! name: "Magic Pen", sku: "magp100", price: 50000

      post '/v1/reset', {}, auth('admin', 'password')

      assert_equal 200, response.status
      assert_json_response(
        "status_code" => 200,
        "message" => "The web store has been reset!"
      )

      assert_equal 3, Product.count

      assert_equal 0, Product.where(sku: "magp100").count
    end

    it "requires authentication to reset products" do
      Product.create! name: "Magic Pen", sku: "magp100", price: 50000

      post '/v1/reset'

      assert_equal 401, response.status
      assert_equal 1, Product.count

      assert_equal 1, Product.where(sku: "magp100").count
    end
  end
end
