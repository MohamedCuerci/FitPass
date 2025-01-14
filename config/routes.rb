Rails.application.routes.draw do
  devise_for :users
  # get "home/index"
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # rotas mercado pago
  # get "payments/new"
  # post 'payments/process_payment', to: 'payments#process_payment'
  # get 'status_payment/:payment_id', to: 'payments#status', as: 'status_payment'

  namespace :payments do
    # stripe
    # get 'stripe/new', to: 'stripe#new'
    resources :stripe, only: [ :new, :create ] do
      collection do
        # get :success
        get :status
      end
    end

    # Mercado Pago
    get "mercado_pago/new", to: "mercado_pago#new"
    post "mercado_pago/process_payment", to: "mercado_pago#process_payment"
    get "mercado_pago/status_payment/:payment_id", to: "mercado_pago#status", as: "mercado_pago_status_payment"
  end
end
