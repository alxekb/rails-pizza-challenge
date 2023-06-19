# frozen_string_literal: true

module Orders
  class Decorator
    def initialize(orders)
      @orders = Array.wrap(orders)
    end

    def price; end
  end
end
