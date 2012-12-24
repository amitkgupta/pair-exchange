require 'spec_helper'

describe SessionsController do
    describe "#logout" do
    	subject do
    		delete :logout
    	end
    
    	it "should route" do
    		{ delete: 'logout' }.should route_to(
    			controller: 'sessions',
    			action: 'logout'
    		)
    	end
    	
    	it "should reset the session" do
			fake_login_user
			
			session.should_not be_blank
    		
    		subject
    		
    		session.should be_blank
    	end
    	
    	it "should redirect to root path" do
    		subject
    		
    		response.should redirect_to(root_path)
    	end
    end
    	
  	describe "#google_auth_callback" do
  		subject do
  			get :google_auth_callback, code: "code"
  		end
  		
		describe "routing from sessions/google_auth_callback" do
			context "when a code is given in the query parameter" do
				it "should route successfully" do
					pending "There is a known issue with RSpec testing routes with constraints"
					
					{ get: 'sessions/google_auth_callback', code: 'code' }.should route_to(
						controller: 'sessions',
						action: 'google_auth_callback'
					)
				end
			end
			
			context "when no code is given" do
				it "should not route" do
					pending "There is a known issue with RSpec testing routes with constraints"

					{ get: 'sessions/google_auth_callback' }.should_not be_routable
				end
			end
		end
				
      	it "should not log in a non-pivotal user" do
    		pending "if we implement this, can we get an @pivotallabs.com test account for request specs?"
    		
    		GoogleApiInterface.any_instance.should_receive(:authorize_from_code).with("code")
			GoogleApiInterface.any_instance.stub(:current_user_email).and_return("pivotallabs.com@thoughtbot.com")
				
			session.should be_blank
				
			expect { subject }.to_not change { session }
		end    			
    	
    	describe "redirecting" do
    		before do
    			GoogleApiInterface.any_instance.should_receive(:authorize_from_code).with("code")
				GoogleApiInterface.any_instance.stub(:current_user_google_id).and_return("123456")
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

		context "when the session already has a google id" do
			it "should not modify the email or refresh token in the session" do
				session[:google_id] = "123456"
				
				expect { subject }.to_not change { session }
			end
		end
		
		context "when the session has no google id" do
			before do
				session.should be_blank
			end
			
			context "when a valid authorization code is provided" do
				it "should set the session google id" do
					GoogleApiInterface.any_instance.should_receive(:authorize_from_code).with("code")
					GoogleApiInterface.any_instance.stub(:current_user_google_id).and_return("123456")
			
					subject    		
						
					session[:google_id].should == "123456"
				end

				context "when the user is new" do
					it "should create the new user" do
						GoogleApiInterface.any_instance.should_receive(:authorize_from_code).with("code")
						GoogleApiInterface.any_instance.stub(:current_user_google_id).and_return("123456")
			
						expect { subject }.to change { User.where(google_id: "123456").count }.by(1)
					end
				end
		
				context "when the user is returning" do
					it "should find the existing user" do
						User.create(google_id: "123456")
						GoogleApiInterface.any_instance.should_receive(:authorize_from_code).with("code")
						GoogleApiInterface.any_instance.stub(:current_user_google_id).and_return("123456")
			
						expect { subject }.to_not change { User.where(google_id: "123456").count }					
					end
				end
			end

			context "when an invalid authorization code is provided" do
				it "should not reset the session" do
					GoogleApiInterface.any_instance.stub(:exchange_code_for_refresh_token).with("code").and_raise("Google API authorization code invalid")

					expect { subject }.to_not change { session }
				end
			end
		end
	end
end