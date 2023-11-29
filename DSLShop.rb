# Create a DSL for calculating discounts in an online store
class StoreDSL
  attr_reader :discounts

  def initialize
    @discounts = []
  end

  def add_discount(discount)
    @discounts << discount
  end
end

# Create a discount for the quantity of goods in the basket
class QuantityDiscount
  attr_reader :quantity, :discount_percentage

  def initialize(quantity, discount_percentage)
    @quantity = quantity
    @discount_percentage = discount_percentage
  end
end

# Create a discount for users with a certain status
class StatusDiscount
  attr_reader :status, :discount_percentage

  def initialize(status, discount_percentage)
    @status = status
    @discount_percentage = discount_percentage
  end
end

# Create a discount for using a promo code
class PromoCodeDiscount
  attr_reader :promo_code, :discount_percentage

  def initialize(promo_code, discount_percentage)
    @promo_code = promo_code
    @discount_percentage = discount_percentage
  end
end

# Create a discount for the purchase of goods in a certain category
class CategoryDiscount
  attr_reader :category, :discount_percentage

  def initialize(category, discount_percentage)
    @category = category
    @discount_percentage = discount_percentage
  end
end

# Create a discount for the purchase of goods in a certain period of time
class TimeDiscount
  attr_reader :start_time, :end_time, :discount_percentage

  def initialize(start_time, end_time, discount_percentage)
    @start_time = start_time
    @end_time = end_time
    @discount_percentage = discount_percentage
  end
end

# Create a discount for order size
class OrderSizeDiscount
  attr_reader :order_size, :discount_percentage

  def initialize(order_size, discount_percentage)
    @order_size = order_size
    @discount_percentage = discount_percentage
  end
end

# Create a discount for using a certain payment method
class PaymentMethodDiscount
  attr_reader :payment_method, :discount_percentage

  def initialize(payment_method, discount_percentage)
    @payment_method = payment_method
    @discount_percentage = discount_percentage
  end
end

# Create a discount for registering for the newsletter
class NewsletterDiscount
  attr_reader :discount_percentage

  def initialize(discount_percentage)
    @discount_percentage = discount_percentage
  end
end

# Create a discount for using a specific browser
class BrowserDiscount
  attr_reader :browser, :discount_percentage

  def initialize(browser, discount_percentage)
    @browser = browser
    @discount_percentage = discount_percentage
  end
end

# Implement the DSL for the online store
dsl = StoreDSL.new

dsl.add_discount(QuantityDiscount.new(10, 10))
dsl.add_discount(StatusDiscount.new('Premium', 15))
dsl.add_discount(PromoCodeDiscount.new('DISCOUNT10', 10))
dsl.add_discount(CategoryDiscount.new('Electronics', 10))
dsl.add_discount(TimeDiscount.new('2023-11-25', '2023-11-30', 20))
dsl.add_discount(OrderSizeDiscount.new(500, 15))
dsl.add_discount(PaymentMethodDiscount.new('PayPal', 10))
dsl.add_discount(NewsletterDiscount.new(10))
dsl.add_discount(BrowserDiscount.new('Chrome', 10))

class Order
  attr_reader :quantity, :status, :promo_code, :category, :order_size, :payment_method, :newsletter, :browser

  def initialize(quantity, status, promo_code, category, order_size, payment_method, newsletter, browser)
    @quantity = quantity
    @status = status
    @promo_code = promo_code
    @category = category
    @order_size = order_size
    @payment_method = payment_method
    @newsletter = newsletter
    @browser = browser
  end

  def calculate_total_price(discounts)
    total_price = 1000  # Assuming an initial total price of $1000

    discounts.each do |discount|
      case discount
      when QuantityDiscount
        if @quantity >= discount.quantity
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Quantity Discount: -$#{discount_amount.round(2)}"
        end
      when StatusDiscount
        if @status == discount.status
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Status Discount: -$#{discount_amount.round(2)}"
        end
      when PromoCodeDiscount
        if @promo_code == discount.promo_code
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Promo Code Discount: -$#{discount_amount.round(2)}"
        end
      when CategoryDiscount
        if @category == discount.category
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Category Discount: -$#{discount_amount.round(2)}"
        end
      when TimeDiscount
        current_time = Time.now.strftime('%Y-%m-%d')
        if current_time >= discount.start_time && current_time <= discount.end_time
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Time Discount: -$#{discount_amount.round(2)}"
        end
      when OrderSizeDiscount
        if @order_size >= discount.order_size
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Order Size Discount: -$#{discount_amount.round(2)}"
        end
      when PaymentMethodDiscount
        if @payment_method == discount.payment_method
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Payment Method Discount: -$#{discount_amount.round(2)}"
        end
      when NewsletterDiscount
        if @newsletter
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Newsletter Discount: -$#{discount_amount.round(2)}"
        end
      when BrowserDiscount
        if @browser == discount.browser
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Applied Browser Discount: -$#{discount_amount.round(2)}"
        end
      end
    end

    total_price
  end
end

# Применяем скидки к заказу
order = Order.new(15, 'Premium', 'DISCOUNT10', 'Electronics', 600, 'PayPal', true, 'Chrome')
total_price_after_discounts = order.calculate_total_price(dsl.discounts)

puts "Total Price after Discounts: $#{total_price_after_discounts.round(2)}"