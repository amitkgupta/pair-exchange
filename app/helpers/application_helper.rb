module ApplicationHelper
	def current_user
		User.find_by_google_id(session[:google_id])
	end

	def google_api_interface
		@google_api_interface ||= GoogleApiInterface.new
	end
end
