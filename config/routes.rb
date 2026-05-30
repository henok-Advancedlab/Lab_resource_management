Rails.application.routes.draw do
  # RESTful JSON API endpoints (no nesting)
  resources :categories, only: %i[index show create update destroy]
  resources :equipment, only: %i[index show create update destroy]
  resources :maintenance_records, only: %i[index show create update destroy]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
