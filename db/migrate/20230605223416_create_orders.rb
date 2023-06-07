# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0] # :nodoc:
  def change
    create_table :orders, id: :uuid do |t|
      t.string :state
      t.jsonb :items
      t.jsonb :promotion_codes
      t.string :discount_code

      t.timestamps
    end
  end
end
