require_relative '../../app/models/google_api_interface.rb'
require 'ostruct'

describe GoogleApiInterface do
	before do
		described_class.stub(:host).and_return("http://localhost:3000/")
		described_class.stub(:permanent_refresh_token).and_return("permanent_refresh_token")
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
				"redirect_uri" => "http://localhost:3000/sessions/google_auth_callback",
				"response_type" => "code",
				"scope" =>  "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/plus.me"
			}
		end
	end
	
	describe "#authorize_from_code" do
		it "fetches an access token with the given code" do
			subject.client.authorization.should_receive(:code=).with("code")
			subject.client.authorization.should_receive(:fetch_access_token!)
			
			subject.authorize_from_code("code")
		end
	end
	
	describe "#authorize_from_refresh_token" do
		it "fetches an access token with the given refresh_token" do
			subject.client.authorization.should_receive(:refresh_token=).with("refresh_token")
			subject.client.authorization.should_receive(:fetch_access_token!)
			
			subject.authorize_from_refresh_token("refresh_token")
		end
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
	
	describe "#current_user_google_id" do
		it "returns the current user's google id" do
			oauth2_api = OpenStruct.new(userinfo: OpenStruct.new(get: :user_info_get_method))
			response = OpenStruct.new(data: OpenStruct.new(id: '123456'))

			subject.client.should_receive(:discovered_api)
				.with('oauth2')
				.and_return(oauth2_api)
			subject.client.should_receive(:execute)
				.with(api_method: :user_info_get_method)
				.and_return(response)
				
			subject.current_user_google_id.should == '123456'
		end
	end
	
	describe "#image_url_for_user" do
		it "refreshses access and then returns the given user's Google+ profile photo url" do
			google_plus_api = OpenStruct.new(people: OpenStruct.new(get: :user_get_method))
			mock_data = double()
			mock_data.stub(:to_hash).and_return({"image" => {"url" => "http://some.image/url.jpg"}})
			response = OpenStruct.new(data: mock_data)
					
			subject.should_receive(:authorize_from_refresh_token).with("permanent_refresh_token")
			subject.client.should_receive(:discovered_api)
				.with('plus')
				.and_return(google_plus_api)
			subject.client.should_receive(:execute)
				.with(:user_get_method, {'userId' => "123456"})
				.and_return(response)
			
			subject.image_url_for_user("123456").should == "http://some.image/url.jpg"
		end
		
		context "when the search yields no result" do
			it "should yield the default user image path" do
				google_plus_api = OpenStruct.new(people: OpenStruct.new(get: :user_get_method))
				mock_data = double()
				mock_data.stub(:to_hash).and_return({"error" => "errors"})
				response = OpenStruct.new(data: mock_data)		

				subject.should_receive(:authorize_from_refresh_token).with("permanent_refresh_token")
				subject.client.should_receive(:discovered_api)
					.with('plus')
					.and_return(google_plus_api)
				subject.client.should_receive(:execute)
					.with(:user_get_method, {'userId' => "123456"})
					.and_return(response)
				
				subject.image_url_for_user("123456").should == "http://localhost:3000/assets/default_google_profile_image.png"
			end
		end
	end

	describe "#display_name_for_user" do
		it "refreshses access and then returns the given user's Google+ display name" do
			google_plus_api = OpenStruct.new(people: OpenStruct.new(get: :user_get_method))
			mock_data = double()
			mock_data.stub(:to_hash).and_return({"displayName" => "Jay Pivot"})
			response = OpenStruct.new(data: mock_data)
					
			subject.should_receive(:authorize_from_refresh_token).with("permanent_refresh_token")
			subject.client.should_receive(:discovered_api)
				.with('plus')
				.and_return(google_plus_api)
			subject.client.should_receive(:execute)
				.with(:user_get_method, {'userId' => "123456"})
				.and_return(response)
			
			subject.display_name_for_user("123456").should == "Jay Pivot"
		end
		
		context "when the search yields no result" do
			it "should yield 'Jonathan Dough'" do
				google_plus_api = OpenStruct.new(people: OpenStruct.new(get: :user_get_method))
				mock_data = double()
				mock_data.stub(:to_hash).and_return({"error" => "errors"})
				response = OpenStruct.new(data: mock_data)		

				subject.should_receive(:authorize_from_refresh_token).with("permanent_refresh_token")
				subject.client.should_receive(:discovered_api)
					.with('plus')
					.and_return(google_plus_api)
				subject.client.should_receive(:execute)
					.with(:user_get_method, {'userId' => "123456"})
					.and_return(response)
				
				subject.display_name_for_user("123456").should == "Jonathan Dough"
			end
		end
	end
end