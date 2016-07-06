class OrdersController < ApplicationController
	autocomplete :menu, :name, extra_data: [:price, :code]

	def index
    @orders = Order.all
  end

	def new
		@order = Order.new
		@order_items = @order.order_items
		@order.order_items.build

		session[:order_id] = @order.id
	end

	def create
		if add_item_param
			@order_item = OrderItem.new(order_item_params)
			@order_item.order_id = session[:order_id]
			puts(@order_item.inspect)
			@order_item.save
			respond_to do |format|
				format.html { redirect_to(:back)}
			end
		else
			@order = Order.new(order_params)
			@order.save
			respond_to do |format|
				format.html { redirect_to action: 'index'}
			end
		end
	end

private
	def order_item_params
		params.require(:order_item).permit(:menu_id, :code, :name, :unit_price, :quantity)
	end

	def add_item_param
		params.permit(:add_item)
	end

	def order_params
		params.require(:order).permit(:id, :customer_id)
	end

end
