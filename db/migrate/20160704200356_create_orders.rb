class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :subtotal
      t.decimal :tax
      t.decimal :tip
      t.decimal :total

      t.timestamps null: false
    end
  end
end
