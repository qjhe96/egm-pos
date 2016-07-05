class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :code
      t.string :name
      t.decimal :price

      t.timestamps null: false
    end
  end
end
