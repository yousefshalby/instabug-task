require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  resources :applications, only: [ :create, :update, :show,  :index ] do
    resources :chats, only: [ :index, :create, :show ] do
      resources :messages, only: [ :create ] do
        collection do
          get :search
        end
      end
    end
  end

  # Health check route
  get "up", to: "rails/health#show", as: :rails_health_check
  # PWA files
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
end
