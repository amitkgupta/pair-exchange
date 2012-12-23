def login(email)
  session[:email] = email
  session[:google_api_refresh_token] = "refresh_token"
end