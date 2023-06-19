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
#
class Order < ApplicationRecord
  # Order::STATES
  # is a list of all the possible states an order can be in
  STATES = Struct.new(:open, :closed).new('OPEN', 'CLOSED').freeze

  after_initialize :set_defaults

  validates :state, inclusion: { in: STATES.values }

  private

  def set_defaults # :nodoc:
    self.state ||= STATES.open
    self.items ||= []
    self.promotion_codes ||= []
  end
end
