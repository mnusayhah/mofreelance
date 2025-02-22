Rails.application.routes.draw do
  #get 'dashboard/company'
  #get 'dashboard/freelancer'

  get 'reviews/test'
  # get 'reviews/create'
  # get 'reviews/show'
  # get 'reviews/edit'
  # get 'reviews/update'
  # get 'reviews/destroy'
  # get 'users/index'
  # get 'users/show'
  # get 'users/edit'
  # get 'users/update'

  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # resources :messages, only: [:index, :show]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # get 'company_dashboard', to: 'dashboard#company', as: :company_dashboard
  # get 'my_projects', to: 'projects#my_projects', as: :my_projects
  # get 'dashboard', to: 'dashboard#company'
  # get 'dashboard/update_content', to: 'dashboard#update_content'
  # get 'dashboard', to: 'dashboard#index'
  # get 'ongoing_projects', to: 'dashboard#ongoing_projects'
  # get 'archived_projects', to: 'dashboard#archived_projects'

  # Defines the root path route ("/")
  # root "posts#index"

  # Page de test pour les reviews
  # resources :reviews, only: [:new, :create, :show, :edit, :update, :destroy]
  # get 'reviews/test', to: 'reviews#test'

  # Freelancer Routes
  namespace :freelancer do
    get 'messages/create'
    get 'discussions/index'
    get 'discussions/show'

    resource :dashboard, only: [:show] do
      get 'projects', to: 'dashboards#projects'
    end


    resources :shared_projects, only: [:index, :show] do
      member do
        patch "accept"
        patch "decline"
      end
    end

    # resources :shared_projects do
    #   collection do
    #     get 'my_projects'
    #     get 'ongoing projects'
    #     get 'declined projects'
    #     get 'paid projects'
    #     get 'completed projects'
    #   end
    # end

    resources :discussions, only: [:index, :show] do
      resources :messages, only: [:create]
    end

    resources :profiles, only: [:index, :show, :edit, :update, :destroy] do
      collection do
        get 'me', to: 'profiles#me'
      end

      resources :skills, only: [:index, :create, :edit, :update, :destroy]
      resources :educations, only: [:index, :create, :edit, :update, :destroy]
    end
  end

  # Enterprise Routes
  namespace :enterprise do

    resource :dashboard, only: [:show] do
      get 'projects', to: 'dashboards#projects'
    end
    resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :shared_projects, only: [:edit, :update]
    end

    resources :projects do
      member do
        patch "complete"
        post "share"
      end
    end

    # resources :projects do
    #   collection do
    #     get 'my_projects'
    #     get 'ongoing'
    #     get 'archived'
    #   end
    # end

    resources :discussions, only: [:index, :show] do
      resources :messages, only: [:create]
    end
  end
end
