Rails.application.routes.draw do
  resources :bookings
  resources :vehicles do
    # Member because it's related to a single vehicle else it would be a collection
    member do
      get :download_json # /vehicles/:id/download_json (JSON only)
      get :download_zip # /vehicles/:id/download_zip (JSON + images)
      get :json_response # /vehicles/:id/json_response
    end
  end
  get "home/index"
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
