require 'google/api_client'
class GoogleApiInterface
	def self.client_id; ENV["GOOGLE_OAUTH2_CLIENT_ID"]; end
	def self.client_secret; ENV["GOOGLE_OAUTH2_CLIENT_SECRET"]; end
	def self.user_email_url; "https://www.googleapis.com/auth/userinfo.email"; end
	def self.google_plus_url; "https://www.googleapis.com/auth/plus.me"; end
	def self.host; HOST; end
			
	attr_reader :client

	def initialize
		@client = Google::APIClient.new
		@client.authorization.client_id = GoogleApiInterface.client_id
		@client.authorization.client_secret = GoogleApiInterface.client_secret
		@client.authorization.scope = "#{GoogleApiInterface.user_email_url} #{GoogleApiInterface.google_plus_url}"
		@client.authorization.redirect_uri = "#{GoogleApiInterface.host}google_auth_callback"
	end
	
	def authorization_uri
		@client.authorization.authorization_uri(approval_prompt: :auto)
	end
	
	def authorize_from_code(code)
		@client.authorization.code = code
		@client.authorization.fetch_access_token!
	end
	
	def current_user_email
		@client.execute(api_method: @client.discovered_api('oauth2').userinfo.get).data.email
	end

	def current_user_google_id
		@client.execute(api_method: @client.discovered_api('oauth2').userinfo.get).data.id
	end
	
	def image_url_for_user(google_id)
		data = @client.execute(
		    @client.discovered_api('plus').people.get,
			{'userId' => google_id}
		).data.to_hash
		
		data.has_key?("image") ? data["image"]["url"] : nil
	end
	
	def display_name_for_user(google_id)
		data = @client.execute(
		    @client.discovered_api('plus').people.get,
			{'userId' => google_id}
		).data.to_hash
		
		data.has_key?("displayName") ?  data["displayName"] : nil
	end
end