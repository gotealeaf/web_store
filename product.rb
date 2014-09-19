module WebStore
  class Product < ActiveRecord::Base
    validates :name, :sku, presence: true
  end
end
