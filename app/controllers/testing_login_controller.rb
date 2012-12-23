if Rails.env.test?
  class TestingLoginController < ActionController::Base
    def login
      session[:email] = params[:email]
      session[:google_api_refresh_token] = "refresh_token"
      render :nothing => true
    end
  end
end