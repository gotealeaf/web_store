module WebStore
  class Product < ActiveRecord::Base
    validates :name, :sku, presence: true

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
