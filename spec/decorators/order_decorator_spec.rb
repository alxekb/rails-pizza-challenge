require 'rails_helper'

RSpec.describe OrderDecorator do # rubocop:disable Metrics/BlockLength
  subject(:total) { described_class.new(order).total }

  let(:order) { build(:order, items:) }
  let(:items) do
    [
      {
        "name": 'Tonno',
        "size": 'Medium',
        "add": ['Cheese'],
        "remove": []
      }
    ]
  end

  context 'when promrotion' do
    let(:order) { build(:order, items:, promotion_codes:) }
    let(:promotion_codes) { ['2FOR1'] }
    let(:items) do
      [
        {
          "name": 'Salami',
          "size": 'Small',
          "add": [],
          "remove": []
        },
        {
          "name": 'Salami',
          "size": 'Small',
          "add": [],
          "remove": []
        }
      ]
    end

    it 'applies promotion' do
      expect(total).to eq(6.0)
    end
  end

  context 'when order has multiple items' do
    let(:items) do
      [
        {
          "name": 'Tonno',
          "size": 'Medium',
          "add": ['Cheese'],
          "remove": []
        },
        {
          "name": 'Margherita',
          "size": 'Medium',
          "add": %w[Cheese Onions],
          "remove": []
        }
      ]
    end

    it { is_expected.to eq(23.4) }
  end

  context 'when order is empty' do
    let(:items) { [] }

    it { is_expected.to eq(0) }
  end

  context 'when order has items' do
    it { is_expected.to eq(13.0) }

    context 'when adding ingredients' do
      let(:items) do
        [
          {
            "name": 'Tonno',
            "size": 'Large',
            "add": ['Cheese'],
            "remove": []
          }
        ]
      end

      it { is_expected.to eq(13.0) }
    end
  end
end
