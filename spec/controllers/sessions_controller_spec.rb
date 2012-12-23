require 'spec_helper'

shared_examples "a new login attempt" do
	context "when a valid authorization code is provided" do
		it "should set the session email and refresh token" do
			GoogleApiInterface.any_instance.stub(:exchange_code_for_refresh_token).with("code").and_return("new_refresh_token")
			GoogleApiInterface.any_instance.stub(:current_user_email).and_return("someone@pivotallabs.com")
			
			subject    		
					
			session[:email].should == "someone@pivotallabs.com"
			session[:google_api_refresh_token].should == "new_refresh_token"
		end
	end

	context "when an invalid authorization code is provided" do
		it "should not reset the session email and refresh token" do
			GoogleApiInterface.any_instance.stub(:exchange_code_for_refresh_token).with("code").and_raise("Google API authorization code invalid")

			expect { subject }.to_not change { session }
		end
	end

	context "when no authorization code is provided" do
		it "should clear the session email and refresh token" do
			expect { post :create }.to_not change { session }
		end
	end
end

describe SessionsController do
  	describe "#create" do
  		subject do
  			post :create, code: "code"
  		end
  		
  		it "should route from /oauth2callback" do
  			{ get: "/oauth2callback?code=code" }.should route_to({
  				controller: "sessions",
  				action: "create"
  			})
  		end
  		  	
    	it "should not log in a non-pivotal user"
    	
    	describe "redirecting" do
    		before do
    			GoogleApiInterface.any_instance.stub(:exchange_code_for_refresh_token).with("code").and_return("new_refresh_token")
				GoogleApiInterface.any_instance.stub(:current_user_email).and_return("someone@pivotallabs.com")
			end

			it "should redirect to the root path by default" do
				subject    		

    			response.should redirect_to(root_path)
    		end
    	
    		it "should redirect to the provided final destination if given" do
    			session[:final_redirect] = "/projects/1"
    		
				subject    		
    		
    			response.should redirect_to("/projects/1")
    		end
    	end

		context "when the session is already ready" do
			it "should not modify the email or refresh token in the session" do
				session[:email] = "someone@pivotallabs.com"
				session[:google_api_refresh_token] = "refresh_token"
				
				subject    		
				
				session[:email].should == "someone@pivotallabs.com"
				session[:google_api_refresh_token].should == "refresh_token"
			end
		end
		
		context "when the session is missing an email" do
			before do
				session[:email].should be_blank
				session[:google_api_refresh_token] = "refresh_token"
			end
			
			it_behaves_like "a new login attempt"
		end
		
		context "when the session is missing a refresh token" do
			before do
				session[:google_api_refresh_token].should be_blank
				session[:email] = "someone@pivotallabs.com"
			end

			it_behaves_like "a new login attempt"
		end
	end
end