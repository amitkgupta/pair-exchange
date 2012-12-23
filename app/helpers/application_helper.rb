module ApplicationHelper
	def current_user
		@current_user ||= session[:email]
	end

	def google_api_refresh_token
		@google_api_refresh_token ||= session[:google_api_refresh_token]
	end

	def session_ready?
		current_user.present? && google_api_refresh_token.present?
	end
	
	def google_api_interface
		@google_api_interface ||= GoogleApiInterface.new
	end
end
