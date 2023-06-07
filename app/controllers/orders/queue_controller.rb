# frozen_string_literal: true

module Orders
  # class Orders::QueueController
  #
  # This is the controller for the queue of orders
  class QueueController < ApplicationController
    before_action :queue_orders, only: %i[index]

    def index; end

    private

    def queue_orders
      @queue_orders ||= Orders::QueueQuery.call
    end
  end
end
