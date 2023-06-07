# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders::Queues', type: :request do
  subject { response }

  describe 'GET /index' do
    describe 'http status' do
      before do
        get orders_queue_index_path
      end

      it { is_expected.to have_http_status(:ok) }
    end

    it 'calls the queue query' do
      allow(Orders::QueueQuery).to receive(:call)

      get orders_queue_index_path

      expect(Orders::QueueQuery).to have_received(:call)
    end
  end
end
