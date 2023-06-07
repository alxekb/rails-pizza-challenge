# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Orders::QueueQuery do
  let(:order) { create(:order) }

  describe '.call' do
    subject(:query) { described_class.call }

    before do
      order
    end

    it { is_expected.to be_an(ActiveRecord::Relation) }

    context 'when there are no orders' do
      let(:order) { nil }

      it { is_expected.to be_empty }
    end

    context 'when there are orders' do
      it { is_expected.to include(order) }
    end

    context 'when there are orders in other states' do
      let(:closed_order) { create_list(:order, 2, state: Order::STATES.closed) }

      before do
        closed_order
      end

      it { is_expected.not_to include(closed_order) }
    end
  end
end
