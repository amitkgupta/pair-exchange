class SessionsController < ApplicationController
	skip_before_filter :require_current_user
	
	def google_auth_callback
		unless current_user.present?
			begin
				google_api_interface.authorize_from_code(params[:code])
				session[:google_id] = google_api_interface.current_user_google_id
				User.create_or_update_from_google_data(google_api_interface)
			rescue
			end
		end
		redirect_to session.delete(:final_redirect) || root_path
	end
	
	def logout
		reset_session
	end
end
