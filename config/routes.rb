Rails.application.routes.draw do
  get 'dashboard/company'
  get 'dashboard/freelancer'
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
end
