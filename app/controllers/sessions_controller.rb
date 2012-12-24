class SessionsController < ApplicationController
	skip_before_filter :require_google_api_access
	
	def google_auth_callback
		unless session_ready?
			begin
				session[:google_api_refresh_token] = google_api_interface.exchange_code_for_refresh_token(params[:code])
				session[:email] = google_api_interface.current_user_email
			rescue
			end
		end
		redirect_to session.delete(:final_redirect) || root_path
	end
end
