require_relative '../../app/models/google_api_interface.rb'
require 'ostruct'

describe GoogleApiInterface do
	before do
		described_class.stub(:host).and_return("http://localhost:3000/")
	end
	
	describe "#authorization_uri" do
		it "should be a URI to Google auth with the right parameters" do
			authorization_uri = subject.authorization_uri
			authorization_uri.authority.should == "accounts.google.com"
			authorization_uri.path.should == "/o/oauth2/auth"
			authorization_uri.query_values.should == {
				"access_type" => "offline",
				"approval_prompt" => "force",
				"client_id" => "1030260537524.apps.googleusercontent.com",
				"redirect_uri" => "http://localhost:3000/oauth2callback",
				"response_type" => "code",
				"scope" =>  "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/plus.me"
			}
		end
	end
	
	describe "#exchange_code_for_refresh_token" do
		it "exchanges the code for a refresh token" do
			subject.client.authorization.should_receive(:code=).with("code")
			subject.client.authorization.should_receive(:fetch_access_token!)
			subject.client.authorization.stub(:refresh_token).and_return("refresh_token")
			
			subject.exchange_code_for_refresh_token("code").should == "refresh_token"
		end
		
		it "raises an error if it fails to exchange the code for the tokens"
	end
	
	describe "#current_user_email" do
		it "returns the current user's email" do
			oauth2_api = OpenStruct.new(userinfo: OpenStruct.new(get: :user_info_get_method))
			response = OpenStruct.new(data: OpenStruct.new(email: 'someone@pivotallabs.com'))

			subject.client.should_receive(:discovered_api)
				.with('oauth2')
				.and_return(oauth2_api)
			subject.client.should_receive(:execute)
				.with(api_method: :user_info_get_method)
				.and_return(response)
				
			subject.current_user_email.should == 'someone@pivotallabs.com'
		end
	end
end