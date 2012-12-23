PairExchange::Application.routes.draw do
  root to: 'projects#index'

  resources :projects do
    resources :interests, only: :create
  end

  resource :sessions, only: :create
  get '/oauth2callback', to: 'sessions#create'
  
  get 'test_login', to: 'testing_login#login', as: :test_login if Rails.env.test?
end
