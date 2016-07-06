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
		if order_params[:add_item]
			@order_item = OrderItem.new
			p order_params[:order_item]
			puts(@order_item.inspect)
			@order_item.menu_id = order_params[:order_item][:menu_id]
			@order_item.code = order_params[:order_item][:code]
			@order_item.name = order_params[:order_item][:name]
			@order_item.quantity = order_params[:order_item][:quantity]
			@order_item.unit_price = order_params[:order_item][:unit_price]
			@order_item.order_id = session[:order_id]
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

	def order_params
		params.require(:order).permit(:id, :customer_id)
		params.require(:order_item).permit!
		params.permit(:add_item)
	end

end
