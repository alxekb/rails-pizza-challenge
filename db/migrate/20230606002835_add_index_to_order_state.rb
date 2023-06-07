# frozen_string_literal: true

class AddIndexToOrderState < ActiveRecord::Migration[7.0]
  def change
    add_index :orders, :state
  end
end