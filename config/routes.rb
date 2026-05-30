Rails.application.routes.draw do
task-7-edge-cases
  # Health check route
  resources :maintenance_records, only: %i[index show create update destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
 main
  get "up" => "rails/health#show", as: :rails_health_check

  # Clean, standard RESTful JSON API endpoints for Categories and Equipment
  resources :categories, only: [:index, :show, :create, :update, :destroy]
  resources :equipment, only: [:index, :show, :create, :update, :destroy]
end