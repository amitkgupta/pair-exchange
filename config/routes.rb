PairExchange::Application.routes.draw do
  root to: 'projects#index'

  resources :projects, except: :show do
    member do
      get 'schedule'
      put 'update_schedule'
    end
  end
  
  resources :interests, only: :create
  delete '/interests', {
  	to: 'interests#destroy',
  	as: :interest
  }

  get '/google_auth_callback', { 
  	to: 'sessions#google_auth_callback', 
  	as: :google_auth_callback
  }
  get '/logout', {
    to: 'sessions#logout',
    as: :logout
  }
  
  resources :events, only: [:create, :new, :index]
  
  get 'test_login', to: 'testing_login#login', as: :test_login if Rails.env.test?
end
