Rails.application.routes.draw do
  get 'dashboard/company'
  get 'dashboard/freelancer'

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

  # resources :messages, only: [:index, :show]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'company_dashboard', to: 'dashboard#company', as: :company_dashboard
  # get 'my_projects', to: 'projects#my_projects', as: :my_projects
  get 'dashboard', to: 'dashboard#company'
  get 'dashboard/update_content', to: 'dashboard#update_content'
  # get 'dashboard', to: 'dashboard#index'
  # get 'ongoing_projects', to: 'dashboard#ongoing_projects'
  # get 'archived_projects', to: 'dashboard#archived_projects'

  # Defines the root path route ("/")
  # root "posts#index"

  # resources :users do
    # resources :projects
  # end

  resources :users do
    resources :projects do
      collection do
        get 'my_projects'
        get 'ongoing'
        get 'archived'
      end
    end
  end

  resources :projects do
    member do
      post 'share'
    end
  end

    # Routes pour les freelances (seuls leurs profils sont visibles)
    resources :profiles, only: [:index, :show, :create, :edit, :update, :destroy] do
      collection do
        get 'me', to: 'profiles#me'
      end
      resources :skills, only: [:index, :create, :edit, :update, :destroy]
      resources :educations, only: [:index, :create, :edit, :update, :destroy]
    end

    # Routes pour les projets (créés par les entreprises, visibles par les freelances)
    resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :shared_projects, only: [:edit, :update]
    end

    # Routes pour les messages (messagerie entre freelances et entreprises)
    resources :discussions, only: [:index, :show, :create] do
      resources :messages, only: [:create]
    end

    # Route pour la gestion des entreprises (elles ne sont pas listées)
    resources :users, only: [] do
      resources :projects, only: [:index] # Pour qu'une entreprise voie ses propres projets
      resources :shared_projects, only: [:index, :show]
    end

    # Page de test pour les reviews
    get 'reviews/test', to: 'reviews#test'

    # Routes pour les reviews
    resources :reviews, only: [:new, :create, :show, :edit, :update, :destroy]


  end
