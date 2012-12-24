require "spec_helper"

describe ApplicationController do
	controller do
    	def index; render nothing: true; end
	end

	describe "#require_google_api_access" do
  		context "if the user is not logged in" do
  			it "should redirect to Google for authorization if the session is not ready" do
				get :index

				response.should redirect_to(GoogleApiInterface.new.authorization_uri.to_s)
			end
		end
		
		context "if the user is logged in" do
			it "should not redirect the user" do
				User.create(google_id: "123456")
				session[:google_id] = "123456"
				
				get :index
				
				response.should_not be_redirect
				response.status.should == 200
			end
		end
    end
end