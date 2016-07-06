class OrderItem < ActiveRecord::Base
  belongs_to :menu
  belongs_to :order

  def total_price
    unit_price * quantity
  end

end
