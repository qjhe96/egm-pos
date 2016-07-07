class OrderItemsController < ApplicationController

	def new
		@order_item = OrderItem.new
		@menus = Menu.all
	end

  def create
  	@order_item = OrderItem.new(order_item_params)
    @order_item.order_id = session[:order_id]
    @order_item.save
    respond_to do |format|
      format.html { redirect_to action: 'new'}
      format.js { refresh }
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
    params.require(:order_item).permit(:id, :menu_id, :code, :name, :unit_price, :quantity)
    end
end
