Rails.application.routes.draw do
  devise_for :users

  # Defines the root path route ("/")
  root to: "pages#about"
  resources :products, only: [:index, :show]
  resources :orders, only: [:show, :create]
  resources :carts, only: [:show]
  delete '/cartproducts/:id', to: 'cartproducts#destroy', as: 'destroy_cart_product'
  resources :cartproducts, only: [:create, :update]
end
