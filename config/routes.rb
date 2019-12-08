Rails.application.routes.draw do
  get 'home/index'
  scope :dashboard do
    get '', to: 'dashboard#index', as: :dashboard
  end
  
  namespace :admin do
    resources :companies, except: [:destroy] do
      get :export, on: :collection
      resources :restaurants, except: [:destroy] do
        
      end
    end
    resources :restaurants, except: [:destroy] do
      get :export, on: :collection
    end
  end

  devise_for :users, controllers: {
    confirmations: 'local_devise/confirmations',
    registrations: 'local_devise/registrations',
    sessions: 'local_devise/sessions',
    unlocks: 'local_devise/unlocks',
    passwords: 'local_devise/passwords'
  }

  devise_scope :user do
    post 'users/otp', :to => 'local_devise/sessions#otp', :as => :users_otp
  end

  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end

  root to: redirect('users/sign_in')

  as :user do
    put '/user/confirmation', to: 'local_devise/confirmations#update', :as => :update_user_confirmation
  end
  
  get :register, to: 'home#register', as: :register
end
