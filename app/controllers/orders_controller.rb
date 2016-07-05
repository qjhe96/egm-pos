class OrdersController < ApplicationController

	autocomplete :menu, :name
	def index
    @orders = Order.all
  end

	def new
		@order = Order.new
		@order_items = @order.order_items
		@order.order_items.build

		respond_to do |format|
			format.html
			format.json { @menu_items = Menu.search(params[:term])}
		end
	end

	def order_params
		params.require(:orders).permit(:first_name, order_items_attributes: [:menu_id, :quantity])
	end

end
