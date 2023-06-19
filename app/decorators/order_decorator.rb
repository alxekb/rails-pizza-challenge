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
      .yield_self { |price| price - order_promotion }
      .yield_self { |price| discount(price) }
      .round(2)
  end

  private

  attr_reader :order

  def discount_percentage
    Menu['discounts'].dig(order.discount_code, 'deduction_in_percent') || 0
  end

  # @param code String
  # @return Hash
  def promotion_from_menu(code)
    Menu['promotions'][code].presence
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
  def order_promotion
    return 0 if order.promotion_codes.blank?

    order.promotion_codes.map do |code|
      calculate_deduction_for(code)
    end.sum
  end

  def calculate_deduction_for(code) # rubocop:disable Metrics/AbcSize
    deduction = 0
    promotion = promotion_from_menu(code)

    return deduction unless promotion

    target_items = target_promo_items(items, promotion)

    while target_items.size >= promotion['from']
      promotion['to'].times do
        deduction += item_price(target_items.first) * 1.0
      end

      target_items.pop(promotion['from'])
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
    return 0 unless item

    pizza_price(item) + ingredients_price(item)
  end

  # @param item Hash
  # @return Integer
  # calculates price for a single pizza
  def pizza_price(item)
    Menu['pizzas'][item['name']].presence || 0.0
  end

  def ingredient_price(item)
    Menu['ingredients'][item].presence || 0.0
  end

  # @param ingredients Hash
  # @return Float
  # calculates price for ingredients
  def ingredients_price(ingredients)
    ingredients['add']
      .map { |ingredient| ingredient_price(ingredient) }
      .sum
  end

  # @return Float
  # @param item Hash
  # calculates size multiplier for a single item
  def size_multiplier(item)
    Menu['size_multipliers'][item['size']].to_f
  end
end
