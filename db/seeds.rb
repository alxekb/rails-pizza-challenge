# frozen_string_literal: true

begin
  JSON.parse(File.read('data/orders.json')).yield_self do |json_orders|
    json_orders.map do |order|
      Order.create(order.transform_keys(&:underscore))
    end
  end
rescue ActiveRecord::RecordNotUnique # rubocop:disable Lint/SuppressedException
end
