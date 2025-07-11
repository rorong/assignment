Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :organizations do
    member do
      post :join
      patch :approve_member
      delete :remove_member
    end
  end

  # Parental consent routes
  get 'parental_consent/:token', to: 'parental_consent#show', as: :parental_consent
  patch 'parental_consent/:token/approve', to: 'parental_consent#approve', as: :approve_parental_consent
  patch 'parental_consent/:token/reject', to: 'parental_consent#reject', as: :reject_parental_consent

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
