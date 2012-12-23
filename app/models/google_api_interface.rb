require 'google/api_client'
class GoogleApiInterface
	def self.client_id; "1030260537524.apps.googleusercontent.com"; end
	def self.client_secret; "fmD_i-Z7AEZ-ixUBXKAvuIEd"; end
	def self.user_email_url; "https://www.googleapis.com/auth/userinfo.email"; end
	def self.google_plus_url; "https://www.googleapis.com/auth/plus.me"; end
	def self.host; HOST; end
	
	attr_reader :client

	def initialize
		@client = Google::APIClient.new
		@client.authorization.client_id = GoogleApiInterface.client_id
		@client.authorization.client_secret = GoogleApiInterface.client_secret
		@client.authorization.scope = "#{GoogleApiInterface.user_email_url} #{GoogleApiInterface.google_plus_url}"
		@client.authorization.redirect_uri = "#{GoogleApiInterface.host}oauth2callback"
	end
	
	def authorization_uri
		@client.authorization.authorization_uri
	end
	
	def exchange_code_for_refresh_token(code)
		@client.authorization.code = code
		@client.authorization.fetch_access_token!
		@client.authorization.refresh_token
	end
	
	def current_user_email
		@client.execute(api_method: @client.discovered_api('oauth2').userinfo.get).data.email
	end
	
	def image_url_for_user(email)
		@client.execute(
			api_method: @client.discovered_api('plus').people.search,
			parameters: {'query' => email}
		).data.items[0].image.url
	end
end