class Order < ActiveRecord::Base
	belongs_to :customer 
	has_many :order_items
	has_many :menus, through: :order_items
	accepts_nested_attributes_for :order_items, reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true
	
end
