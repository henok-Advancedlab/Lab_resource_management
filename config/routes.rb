Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Clean, standard RESTful JSON API endpoints for Categories and Equipment
  resources :categories, only: [:index, :show, :create, :update, :destroy]
  resources :equipment, only: [:index, :show, :create, :update, :destroy]
end