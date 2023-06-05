# frozen_string_literal: true

# class Order
#
# @!attribute [rw] id
#  @return [UUID] the primary key
#
# @!attribute [rw] state
#  @return [String] the state of the order
#
# @!attribute [rw] created_at
#  @return [DateTime] the date and time the order was created
#
# @!attribute [rw] items
#  @return [Array<Item>] the items in the order
#
# @!attribute [rw] promotionCodes
#  @return [Array<String>] the promotion codes applied to the order
#
# @!attribute [rw] discountCode
#  @return [String] the discount code applied to the order
class Order < ApplicationRecord
end
