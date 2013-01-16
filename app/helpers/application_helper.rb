module ApplicationHelper
	include Redcarpet
	
	def current_user
		User.find_by_google_id(session[:google_id])
	end
	
	def admin_logged_in?
		current_user && current_user.is_admin
	end

	def google_api_interface
		@google_api_interface ||= GoogleApiInterface.new
	end
	
	def markdown(text)
		text ||= ""
		renderer = Render::HTML.new(hard_wrap: true, filter_html: true)
		markdown = Markdown.new(renderer, no_intra_emphasis: true, fenced_code_blocks: true)
		markdown.render(text).html_safe
  	end
end
