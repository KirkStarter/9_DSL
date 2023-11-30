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

# Create a discount for the quantity of same items in the order
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

# Create a discount for the purchase of items in a certain category
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

dsl.add_discount(QuantityDiscount.new(2, 10))
dsl.add_discount(StatusDiscount.new('Newcomer', 3))
dsl.add_discount(StatusDiscount.new('Gold', 5))
dsl.add_discount(StatusDiscount.new('Platinum', 7))
dsl.add_discount(PromoCodeDiscount.new('BIG12', 12))
dsl.add_discount(CategoryDiscount.new('Electronics', 15))
dsl.add_discount(TimeDiscount.new('27.11.2023', '30.11.2023', 25))
dsl.add_discount(OrderSizeDiscount.new(5, 15))
dsl.add_discount(PaymentMethodDiscount.new('SigmaBank Card', 3))
dsl.add_discount(NewsletterDiscount.new(1))
dsl.add_discount(BrowserDiscount.new('TrojanSearcher', 2))

class Item
  attr_reader :name, :category, :price

  def initialize(name, category, price)
    @name = name
    @category = category
    @price = price
  end
end

class Item
  attr_reader :name, :category, :price, :quantity

  def initialize(name, category, price, quantity)
    @name = name
    @category = category
    @price = price
    @quantity = quantity
  end
end

class Order
  attr_reader :items, :status, :promo_code, :payment_method, :newsletter, :browser

  def initialize(items, status, promo_code, payment_method, newsletter, browser)
    @items = items
    @status = status
    @promo_code = promo_code
    @payment_method = payment_method
    @newsletter = newsletter
    @browser = browser
  end

  def calculate_total_price(discounts)
    total_price_before_discounts = @items.sum { |item| item.price * item.quantity }
    puts "Total Price before Discounts: $#{total_price_before_discounts.round(2)}"
    total_price = 0

    @items.each do |item|
      item_price = item.price * item.quantity  # Assuming each item has a price

      discounts.each do |discount|
        case discount
        when CategoryDiscount
          if item.category == discount.category
            discount_amount = item_price * (discount.discount_percentage / 100.0)
            item_price -= discount_amount
            puts "Category Discount to item #{item.name}: -$#{discount_amount.round(2)}"
          end
        when QuantityDiscount
          if item.quantity >= discount.quantity
            discount_amount = item_price * (discount.discount_percentage / 100.0)
            item_price -= discount_amount
            puts "Quantity Discount to item #{item.name}: -$#{discount_amount.round(2)}"
          end
        end
      end

      total_price += item_price
    end

    # Apply other discounts to the total price
    discounts.each do |discount|
      case discount
      when StatusDiscount
        if @status == discount.status
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Status Discount: -$#{discount_amount.round(2)}"
        end
      when PromoCodeDiscount
        if @promo_code == discount.promo_code
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Promo Code Discount: -$#{discount_amount.round(2)}"
        end
      when TimeDiscount
        current_time = Time.now.strftime('%d.%m.%Y')
        if current_time >= discount.start_time && current_time <= discount.end_time
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Time Discount: -$#{discount_amount.round(2)}"
        end
      when OrderSizeDiscount
        if @items.size >= discount.order_size
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Order Size Discount: -$#{discount_amount.round(2)}"
        end
      when PaymentMethodDiscount
        if @payment_method == discount.payment_method
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Payment Method Discount: -$#{discount_amount.round(2)}"
        end
      when NewsletterDiscount
        if @newsletter
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Newsletter Discount: -$#{discount_amount.round(2)}"
        end
      when BrowserDiscount
        if @browser == discount.browser
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Browser Discount: -$#{discount_amount.round(2)}"
        end
      end
    end

    total_price
  end
end


items = [Item.new('DegraPhone', 'Electronics', 1000, 4), Item.new('Zip-top', 'Clothing', 150, 2)]
order = Order.new(items, 'Platinum', 'BIG5', 'SigmaBank Card', true, 'TrojanSearcher')

total_price_after_discounts = order.calculate_total_price(dsl.discounts)

puts "-------------------------------------"
puts "Total Price after Discounts: $#{total_price_after_discounts.round(2)}"
