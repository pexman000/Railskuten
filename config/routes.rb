Rails.application.routes.draw do
  resources :transactions
  get 'cart_items/create'
  get 'cart_items/update'
  get 'cart_items/destroy'
  get 'orders/create'
  get 'products/index'
  get 'products/show'
  get 'products/new'
  get 'products/create'
  get 'products/edit'
  get 'products/update'
  get 'products/destroy'
  root 'products#index'
  resources :registrations
  resources :sessions, only: [:new, :create]
  resources :posts do
    resources :comments do
      get '/add', to: 'comments#new', as: :add_child_comment
      post '/', to: 'comments#create', as: :add_child_comment_parent
    end
  end
  resources :comments
  resources :users
  resources :products do
    patch :buy, on: :member
  end
  resources :buyers
  resources :sellers
  resources :cart
  resources :cart_items
  delete 'logout' => 'sessions#destroy', as: :logout
  get "up" => "rails/health#show", as: :rails_health_check
end
