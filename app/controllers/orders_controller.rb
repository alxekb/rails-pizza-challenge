# frozen_string_literal: true

# class OrdersController
class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(new_order_params)

    if @order.save
      render json: {}
    else
      render json: @order.errors.to_json, status: :unprocessable_entity
    end
  end

  def update
    @order = Order.find(params[:id])

    @order.update(update_order_params)

    redirect_to orders_queue_index_path
  end

  private

  def update_order_params
    params
      .require(:order)
      .permit(:state)
  end

  def new_order_params
    order_params.transform_keys(&:underscore)
  end

  def order_params
    p params[:order]
    params.require(:order)
          .permit(:discountCode,
                  promotionCodes: [],
                  items: [:name, :size, :price, :multiplier, { add: [], remove: [] }])
  end
end
