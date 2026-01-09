Rails.application.routes.draw do
  get "reactions/create"
  get "notifications/index"
  get "direct_messages/new"
  get "direct_messages/create"
  get "messages/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "channels#index"

  # Chat application routes
  resources :channels, only: [ :show, :new, :create ] do
    resources :messages, only: [ :create, :show ] do
      post "reaction", to: "reactions#create"
    end
  end

  # Direct messaging routes
  resources :direct_messages, only: [ :new, :create ]

  # Notification routes
  resources :notifications, only: [ :index ]
end
