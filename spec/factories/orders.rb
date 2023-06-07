# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    state { Order::STATES.open }
    items { [] }
    promotion_codes { [] }
    discount_code { nil }
  end
end
