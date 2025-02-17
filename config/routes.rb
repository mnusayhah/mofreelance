Rails.application.routes.draw do
  get 'reviews/new'
  get 'reviews/create'
  get 'reviews/show'
  get 'reviews/edit'
  get 'reviews/update'
  get 'reviews/destroy'
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

  # Freelancer Routes
  namespace :freelancer do
    get 'messages/create'
    get 'discussions/index'
    get 'discussions/show'
    get "dashboard", to: "dashboards#show"

    resources :shared_projects, only: [:index, :show] do
      member do
        patch "accept"
        patch "decline"
      end
    end

    resources :discussions, only: [:index, :show] do
      resources :messages, only: [:create]
    end

    resources :profiles, only: [:index, :show, :edit, :update, :destroy] do
      resources :skills, only: [:index, :create, :edit, :update, :destroy]
      resources :educations, only: [:index, :create, :edit, :update, :destroy]
    end
  end

  # Enterprise Routes
  namespace :enterprise do
    get "dashboard", to: "dashboards#show"

    resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :shared_projects, only: [:edit, :update]
    end

    resources :projects do
      member do
        patch "complete"
      end

      resources :discussions, only: [:index, :show] do
        resources :messages, only: [:create]
      end

      # resources :reviews, only: [:create]
    end
  end

  # Page de test pour les reviews
  resources :reviews, only: [:new, :create, :show, :edit, :update, :destroy]
  get 'reviews/test', to: 'reviews#test'

end
