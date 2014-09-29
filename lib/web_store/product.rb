module WebStore
  class Product < ActiveRecord::Base
    validates :name, :sku, presence: true
    validates :sku, format: /\w{3,}/, uniqueness: true
    validates :price, numericality: {
      only_integer: true, greater_than: 0,
      message: "must be an integer greater than 0"
    }

    def self.seed!
      create! name: "Red Pen", sku: "redp100", price: 100
      create! name: "Blue Pen", sku: "blup100", price: 100
      create! name: "Black Pen", sku: "blap100", price: 100
    end

    def self.truncate_and_reset_table!
      connection.execute "TRUNCATE TABLE #{table_name} RESTART IDENTITY;"
    end
  end
end
