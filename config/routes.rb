class GoogleCallbackConstraint
  def matches?(request)
    request.params.has_key? :code
  end
end

PairExchange::Application.routes.draw do
  root to: 'projects#index'

  resources :projects do
    resources :interests, only: :create
  end

  get '/sessions/google_auth_callback', { 
  	to: 'sessions#google_auth_callback', 
  	as: :google_auth_callback,
  	constraints: GoogleCallbackConstraint.new
  }
  
  get 'test_login', to: 'testing_login#login', as: :test_login if Rails.env.test?
end
