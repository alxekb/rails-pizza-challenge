# frozen_string_literal: true

# class OrderDecorator
#
# Wraps collection of orders and provides methods to calculate price
class OrderDecorator
  delegate :items, to: :order

  # @return Float
  # @param order Order
  def initialize(order)
    @order = order
  end

  def total
    total_price
      .yield_self { |price| (price - promotion_for(price)) }
      .yield_self { |price| discount(price) }
      .round(2)
  end

  private

  attr_reader :order

  def discount_percentage
    Menu['discounts'][order.discount_code].presence || 0
  end

  # @param code String
  # @return Hash
  def promotion_from_menu(code)
    Menu['promotions'][code]
  end

  # @param price Integer
  # @return Float
  def discount(price)
    price * (1 - (discount_percentage / 100.0))
  end

  # Promotion codes allow to get pizzas for free; e.g., two small salami pizzas for the price of one.
  # Extra ingredients will still be charged though.
  # Multiple promotion codes can be specified per order.
  # A promotion code can also be applied more than once to the same order
  # (a 2-for-1 code automatically reduces 4 pizzas to 2 for one order)
  #
  def promotion_for(price)
    return price if order.promotion_codes.blank?

    order.promotion_codes.map do |code|
      calculate_deduction_for(code)
    end.sum
  end

  def calculate_deduction_for(code)
    promotion = promotion_from_menu(code)
    deduction = 0

    target_items = target_promo_items(items, promotion)

    while target_items.size >= promotion['from']
      promotion['to'].times do
        deduction += (item_price(target_items.first) * size_multiplier(target_items.first)) * 1.0
      end

      items.pop(promotion['from'])
    end

    deduction
  end

  # @param items Array
  # @param promotion Hash
  # @return Array
  # returns only items matching promotion criteria
  def target_promo_items(items, promotion)
    items.map do |item|
      next item unless item['name'] == promotion['target'] &&
                       item['size'] == promotion['target_size']

      item
    end
  end

  # @param items Array
  # @return Float
  # calculates total price for all items
  def total_price
    items.map { |item| item_price(item) }
         .sum
  end

  # @param item Hash
  # @return Float
  # calculates price for a single item
  def item_price(item)
    pizza_with_ingredients_price(item) * size_multiplier(item) * 1.0
  end

  # @param item Hash
  # @return Float
  # calculates price for a single pizza with ingredients
  def pizza_with_ingredients_price(item)
    pizza_price(item) + ingredients_price(item)
  end

  # @param item Hash
  # @return Integer
  # calculates price for a single pizza
  def pizza_price(item)
    Menu['pizzas'][item['name']]
  end

  def ingredient_price(item)
    Menu['ingredients'][item]
  end

  # @param ingredients Hash
  # @return Float
  # calculates price for ingredients
  def ingredients_price(ingredients)
    ingredients['add']
      .map { |ingredient| ingredient_price(ingredient) }
      .sum
      .to_f
  end

  # @return Float
  # @param item Hash
  # calculates size multiplier for a single item
  def size_multiplier(item)
    Menu['size_multipliers'][item['size']].to_f
  end
end
