Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"


    # Routes pour les freelances (seuls leurs profils sont visibles)
    resources :profiles, only: [:index, :show, :edit, :update, :destroy] do
    end

    # Routes pour les projets (créés par les entreprises, visibles par les freelances)
    resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy]

    # Routes pour les messages (messagerie entre freelances et entreprises)
    resources :discussions, only: [:index, :show, :create] do
      resources :messages, only: [:create]
    end

    # Route pour la gestion des entreprises (elles ne sont pas listées)
    resources :users, only: [] do
      resources :projects, only: [:index] # Pour qu'une entreprise voie ses propres projets
    end
  end
