class ApplicationController < ActionController::Base
    include ApplicationHelper
	protect_from_forgery
	before_filter :require_google_api_access

	private

	def require_google_api_access
		unless session_ready?
			session[:final_redirect] = request.url
			redirect_to google_api_interface.authorization_uri.to_s
		end
	end
end