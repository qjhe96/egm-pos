class OrdersController < ApplicationController

	def index
    @orders = Order.all
  end

	def new
		@order = Order.new
		@order_items = @order.order_items
		@order.order_items.build
	end

	def order_params
		params.require(:orders).permit(:first_name, order_items_attributes: [:menu_id, :quantity])
	end

end
