class OrderItem < ActiveRecord::Base
  belongs_to :menu
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :menu_present
  validate :order_present

  before_save :finalize

  def name
  	menu.name
  end

  def unit_price
    if persisted?
      self[:unit_price]
    else
      menu.price
    end
  end

  def total_price
    unit_price * quantity
  end

  private
    def menu_present
      if menu.nil?
        errors.add(:menu, "is not valid or is not active.")
      end
    end

    def order_present
      if order.nil?
        errors.add(:order, "is not a valid order.")
      end
  	end

    def finalize
	    self[:unit_price] = unit_price
	    self[:total_price] = quantity * self[:unit_price]
    end
end
