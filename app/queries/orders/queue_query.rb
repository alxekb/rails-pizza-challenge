# frozen_string_literal: true

module Orders
  # class Orders::QueueQuery
  #
  #  This is a query object that returns a list of orders in the queue
  class QueueQuery
    #  @return [Array<Order>] the orders in the queue
    def self.call
      Order
        .where(state: Order::STATES.open)
        .order(created_at: :desc)
    end
  end
end
