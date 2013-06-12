class UserPresenter
	DEFAULT_IMAGE_URL = "#{ENV["HOST"]}assets/default_google_profile_image.png"
	attr_reader :display_name, :profile_image_url

	def initialize(user)
		@display_name = user.display_name || user.email
		@profile_image_url = user.profile_image_url || DEFAULT_IMAGE_URL
	end
end
