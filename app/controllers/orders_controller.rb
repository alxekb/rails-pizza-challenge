# frozen_string_literal: true

# class OrdersController
class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params.transform_keys(&:underscore))

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

  def order_params
    params
      .require(:order)
      .except(:promotionCodes)
      .permit(:items, :promotionCodes, :discountCode)
  end
end
