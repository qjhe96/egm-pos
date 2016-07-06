class OrderItemsController < ApplicationController

	def new
		@order_item = OrderItem.new
		@menus = Menu.all
	end

  def create
  	@order = params[:order]
  	@item_params = order[:order_items_attributes]
    @order_item = @order.order_items.new(item_params)
    @order.save
    @order_item.save
  end

  def update
  	@order = current_order
  	@order_item = @order.order_items.find(params[:id])
  	@order_items.update_attributes(order_items_params)
  	@order_items = @order.order_items
  end

  def destroy
  	@order = current_order
  	@order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
  end

  private
  	def order_item_params
    	params.require(:order).permit(:order_items_attributes)
  	end
end
