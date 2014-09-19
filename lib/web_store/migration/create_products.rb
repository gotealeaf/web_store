module WebStore::Migration
  class CreateProducts < ActiveRecord::Migration

    def change
      create_table :products, force: true do |t|
        t.string :name, null: false
        t.string :sku, null: false
        t.integer :price, null: false, default: 0
      end
    end

  end
end
