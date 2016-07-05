class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :menu, index: true
      t.references :order, index: true
      t.decimal :unit_price
      t.integer :quantity
      t.decimal :total_price

      t.timestamps null: false
    end
    add_foreign_key :order_items, :menus
    add_foreign_key :order_items, :orders
  end
end
