# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders::Queues', type: :request do
  subject { response }

  let(:orders) { create_list :order, 2 }

  describe 'GET /index' do
    describe 'http status' do
      before do
        orders
        get root_path
      end

      it { is_expected.to have_http_status(:ok) }
    end

    it 'calls the queue query' do
      query = double(Orders::QueueQuery.name, call: orders)
      allow(Orders::QueueQuery).to receive(:call).and_return(query.call)

      get root_path

      expect(query).to have_received(:call).once
    end
  end
end
