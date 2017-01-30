Rails.application.routes.draw do
  resources :line_items
  resources :carts
  resources :products
  resources :problems do
    resources :answers
  end

  # get 'knowledge_points/all_children' => 'knowledge_points#all_children'
  resources :knowledge_points do
    member do
      get :all_children
    end
  end

  resources :tags do
    member do
      get :all_children
      post :new_children
      post :create_children
    end
  end

  devise_for :users
  resources :users

  root to: 'visitors#index'
end
