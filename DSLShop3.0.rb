require 'date'

# Create a DSL for calculating discounts in an online store
class StoreDSL
  attr_reader :discounts

  def initialize
    @discounts = []
  end

  def add_discount(&block)
    instance_eval(&block)
  end

  def quantity_discount(quantity, discount_percentage)
    @discounts << QuantityDiscount.new(quantity, discount_percentage)
  end

  def status_discount(status, discount_percentage)
    @discounts << StatusDiscount.new(status, discount_percentage)
  end

  def promo_code_discount(promo_code, discount_percentage)
    @discounts << PromoCodeDiscount.new(promo_code, discount_percentage)
  end

  def category_discount(category, discount_percentage)
    @discounts << CategoryDiscount.new(category, discount_percentage)
  end

  def time_discount(start_time, end_time, discount_percentage)
    @discounts << TimeDiscount.new(start_time, end_time, discount_percentage)
  end

  def order_size_discount(order_size, discount_percentage)
    @discounts << OrderSizeDiscount.new(order_size, discount_percentage)
  end

  def payment_method_discount(payment_method, discount_percentage)
    @discounts << PaymentMethodDiscount.new(payment_method, discount_percentage)
  end

  def newsletter_discount(discount_percentage)
    @discounts << NewsletterDiscount.new(discount_percentage)
  end

  def browser_discount(browser, discount_percentage)
    @discounts << BrowserDiscount.new(browser, discount_percentage)
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
    @start_time = DateTime.parse(start_time)
    @end_time = DateTime.parse(end_time)
    @discount_percentage = discount_percentage
  end

  def within_time_period?
    current_time = DateTime.now
    current_time >= @start_time && current_time <= @end_time
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

# Create items and order
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
    puts " "
    puts "===== Your check ====="
    puts "Total Price before Discounts: $#{total_price_before_discounts.round(2)}"
    total_price = 0

    @items.each do |item|
      item_price = item.price * item.quantity

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
        if discount.within_time_period?
          discount_amount = total_price * (discount.discount_percentage / 100.0)
          total_price -= discount_amount
          puts "Time Discount: -$#{discount_amount.round(2)}"
        end
      when OrderSizeDiscount
        total_quantity = @items.sum { |item| item.quantity }
        if total_quantity >= discount.order_size
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

# Console Program
class ConsoleProgram
  def initialize(dsl)
    @dsl = dsl
    @selected_items = []
  end

  def display_menu
    puts " "
    puts "===== Online Store ====="
    puts "1. DegraPhone - Electronics - $1000"
    puts "2. Zip-top - Clothing - $150"
    puts "0. Calculate Total Price"
  end

  def select_item(item_number, quantity)
    case item_number
    when 1
      @selected_items << Item.new('DegraPhone', 'Electronics', 1000, quantity)
    when 2
      @selected_items << Item.new('Zip-top', 'Clothing', 150, quantity)
    end
  end

  def select_status
    puts "Select Status:"
    puts "1. Newcomer"
    puts "2. Ordinary"
    puts "3. Gold"
    puts "4. Platinum"
    print "Enter status number: "
    status_number = gets.to_i

    case status_number
    when 1
      @status = 'Newcomer'
    when 2
      @status = 'Ordinary'
    when 3
      @status = 'Gold'
    when 4
      @status = 'Platinum'
    else
      @status = 'Ordinary' # Default to Ordinary if an invalid option is chosen
    end
  end

  def enter_promo_code
    puts " "
    print "Enter promo code: "
    @promo_code = gets.chomp
  end

  def select_payment_method
    puts " "
    puts "Select Payment Method:"
    puts "1. SigmaBank Card"
    puts "2. Cash "
    print "Enter payment method number: "
    payment_method_number = gets.to_i

    case payment_method_number
    when 1
      @payment_method = 'SigmaBank Card'
    when 2
      @payment_method = 'Cash'
    else
      @payment_method = 'Cash' # Default to Cash if an invalid option is chosen
    end
  end

  def select_newsletter
    puts " "
    puts "Are you subscribed to the newsletter?"
    puts "1. Yes"
    puts "2. No"
    print "Enter newsletter option number: "
    newsletter_option_number = gets.to_i

    @newsletter = newsletter_option_number == 1
  end

  def select_browser
    puts " "
    puts "Select Browser:"
    puts "1. TrojanSearcher"
    puts "2. Another browser"
    print "Enter browser number: "
    browser_number = gets.to_i

    @browser = browser_number == 1 ? 'TrojanSearcher' : 'Another browser'
  end

  def run
    select_status
    enter_promo_code
    select_payment_method
    select_newsletter
    select_browser

    loop do
      display_menu
      print "Enter item number (or 0 to calculate total price): "
      item_number = gets.to_i

      break if item_number == 0

      print "Enter quantity: "
      quantity = gets.to_i

      select_item(item_number, quantity)
    end

    order = Order.new(@selected_items, @status, @promo_code, @payment_method, @newsletter, @browser)
    total_price_after_discounts = order.calculate_total_price(@dsl.discounts)

    puts "-------------------------------------"
    puts "Total Price after Discounts: $#{total_price_after_discounts.round(2)}"
  end
end

# Create DSL and run console program
dsl = StoreDSL.new

dsl.add_discount do
  quantity_discount(2, 10)
  status_discount('Newcomer', 3)
  status_discount('Gold', 5)
  status_discount('Platinum', 7)
  promo_code_discount('BIG5', 5)
  category_discount('Electronics', 15)
  time_discount('01.12.2023', '05.12.2023', 25)
  order_size_discount(5, 15)
  payment_method_discount('SigmaBank Card', 3)
  newsletter_discount(1)
  browser_discount('TrojanSearcher', 2)
end

program = ConsoleProgram.new(dsl)
program.run
