class Order < ActiveRecord::Base
	belongs_to :customer 
	has_many :order_items
	has_many :menus, through: :order_items
	accepts_nested_attributes_for :order_items, reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true
	before_save :update_subtotal
	
	def subtotal
		order_items.collect{ |oi| oi.quantity * oi.price}.sum
	end

	def update_subtotal
		self[:subtotal] = subtotal
	end
end
