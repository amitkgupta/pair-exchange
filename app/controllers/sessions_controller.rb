class SessionsController < ApplicationController
	skip_before_filter :require_current_user
	
	def google_auth_callback
		unless current_user.present?
			begin
				google_api_interface.authorize_from_code(params[:code])
				session[:google_id] = google_api_interface.current_user_google_id
				user = User.find_or_initialize_by_google_id(session[:google_id])
				user.update_attributes(email: google_api_interface.current_user_email)
			rescue
			end
		end
		redirect_to session.delete(:final_redirect) || root_path
	end
	
	def logout
		reset_session
		redirect_to root_path
	end
end
