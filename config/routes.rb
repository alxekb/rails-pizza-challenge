# frozen_string_literal: true

Rails.application.routes.draw do
  resources :orders, only: %i[new create update]

  namespace :orders do
    resources :queue, only: %i[index]
  end

  root 'orders/queue#index'
end
