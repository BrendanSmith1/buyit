Rails.application.routes.draw do
  devise_for :users

  # Defines the root path route ("/")
  root to: "pages#about"
  resources :products, only: [:index, :show]
end
