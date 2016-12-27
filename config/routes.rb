Rails.application.routes.draw do
  resources :line_items
  resources :carts
  resources :products
  resources :problems

  root to: 'store#index', as: 'store'
end
