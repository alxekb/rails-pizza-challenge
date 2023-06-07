# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get '/orders/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST' do
    let(:params) do
      {
        order: { state: Order::STATES.closed }
      }
    end

    subject { response }

    before do
      post '/orders', params:
    end

    it { is_expected.to have_http_status(200) }
  end

  describe 'PATCH' do
    let(:params) do
      {
        order: { state: Order::STATES.closed }
      }
    end
    let(:order) { create(:order) }

    subject { response }

    before do
      patch order_path(order), params:
    end

    it { is_expected.to redirect_to(orders_queue_index_path) }
  end
end
