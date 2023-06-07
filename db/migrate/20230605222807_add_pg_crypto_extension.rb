# frozen_string_literal: true

class AddPgCryptoExtension < ActiveRecord::Migration[7.0] # :nodoc:
  def change
    enable_extension 'pgcrypto'
  end
end
