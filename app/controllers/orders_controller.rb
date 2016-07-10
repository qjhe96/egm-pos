class OrdersController < ApplicationController
	autocomplete :menu, :name, extra_data: [:price, :code]
	before_filter :set_items, only: [:update, :increment, :decrement, :destroy_item]
	helper_method [:subtotal, :tax, :tip, :total]

	def set_items
		@order = Order.find(session[:order_id])
		@order_items = @order.order_items
	end

	def index
    @orders = Order.all
  end

	def new
		@order = Order.find(session[:order_id])
		@order_items = @order.order_items
	rescue ActiveRecord::RecordNotFound
		@order = Order.create
		@order_items = @order.order_items
		session[:order_id] = @order.id
	end

	def create
		@order.customer_id = order_params[:customer_id]
		@order.subtotal = subtotal
		@order.tax = tax
		@order.tip = tip
		@order.total = total
		@order.save
		session.delete(:order_id)
		session.delete(:customer_id)
		respond_to do |format|
			format.html { redirect_to action: 'index'}
		end
	end

	def update
		if add_item_param.has_key?(:add_item)
			@order_item = OrderItem.new(order_item_params)
			@order_item.order_id = session[:order_id]
			@order_item.save
			respond_to do |format|
				format.html { redirect_to action: 'new'}
				format.js { refresh }
			end
		elsif find_customer_param.has_key?(:find_customer)
			@customer = Customer.where(phone: customer_params[:phone]).first
			if @customer.nil?
				respond_to do |format|
					format.js {refresh}
				end
			else
				session[:customer_id] = @customer.id
				respond_to do |format|
					format.html { redirect_to action: 'new'}
					format.js { refresh }
				end
			end
		end
	end

	def destroy_item
		OrderItem.destroy(order_item_id_param)
		respond_to do |format|
				format.html { redirect_to action: 'new'}
				format.js { refresh}
		end
	end

	def increment
		@order_item = OrderItem.find(order_item_id_param)
		@order_item.increment! :quantity
		respond_to do |format|
				format.html { redirect_to action: 'new'}
				format.js { refresh}
		end
	end

	def decrement
		@order_item = OrderItem.find(order_item_id_param)
		@order_item.decrement! :quantity
		respond_to do |format|
				format.html { redirect_to action: 'new'}
				format.js { refresh}
		end
	end

	def subtotal
		@order = Order.find(session[:order_id])
		@order_items = @order.order_items
		@total = 0
		@order_items.each do |item|
			@total += item.quantity * item.unit_price
		end
	  @total
	end

	def tax
		subtotal * 0.18
	end

	def tip
		subtotal * 0.10
	end

	def total
		subtotal + tax + tip
	end

	def refresh
		render(file: 'orders/reload.js.erb')
	end

private
	def order_item_id_param
		params.require(:order_item_id)
	end

	def order_item_params
		params.require(:order_item).permit(:id, :menu_id, :code, :name, :unit_price, :quantity)
	end

	def add_item_param
		params.permit(:add_item)
	end

	def find_customer_param
		params.permit(:find_customer)
	end

	def customer_params
		params.require(:customer).permit(:id, :firstname, :lastname, :phone, :address)
	end

	def order_params
		params.require(:order).permit(:id, :customer_id)
	end

end
