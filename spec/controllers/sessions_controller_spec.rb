require 'spec_helper'

describe SessionsController do
    describe "#logout" do
    	subject do
    		get :logout
    	end
    
    	it "should route" do
    		{ get: 'logout' }.should route_to(
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
			it "should route successfully when a code is given in the query string" do
				pending "There is a known issue with RSpec testing routes with constraints"
			end
			
			it "should not route when there is no code" do
				pending "There is a known issue with RSpec testing routes with constraints"
			end
		end  			
    	
    	describe "redirecting" do
    		before do
    			GoogleApiInterface.any_instance.should_receive(:authorize_from_code).with("code")
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
			it "should not modify the session" do
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
					before do
						GoogleApiInterface.any_instance.should_receive(:authorize_from_code).with("code")
						GoogleApiInterface.any_instance.stub(:current_user_google_id).and_return("123456")
						GoogleApiInterface.any_instance.stub(:current_user_email).and_return("someone@pivotallabs.com")
						GoogleApiInterface.any_instance.stub(:display_name_for_user).with("123456").and_return("An Lo")
						
						User.where(google_id: "123456").count.should == 0
					end
					
					context "when the Google API delivers all the attributes" do
						it "should create the new user and set the attributes" do
							GoogleApiInterface.any_instance.stub(:image_url_for_user).with("123456").and_return("foo.com/img.jpg")
						
							subject

							User.where(google_id: "123456").count.should == 1
							User.find_by_google_id("123456").email.should == "someone@pivotallabs.com"
							User.find_by_google_id("123456").profile_image_url.should == "foo.com/img.jpg"
							User.find_by_google_id("123456").display_name.should == "An Lo"
						end
					end
					
					context "when Google fails to deliver some data" do
						it "should create the new user and leave the appropriate fields nil" do
							GoogleApiInterface.any_instance.stub(:image_url_for_user).with("123456").and_return(nil)

							subject

							User.where(google_id: "123456").count.should == 1
							
							user = User.find_by_google_id("123456")
							user.email.should == "someone@pivotallabs.com"
							user.profile_image_url.should be_blank
							user.display_name.should == "An Lo"
						end
					end
				end
		
				context "when the user is returning" do
					it "should update the existing user" do
						User.create(
							google_id: "123456",
							email: "old@email.com",
							display_name: "Old Name",
							profile_image_url: "oldsite.com/deleted_photo.jpg"
						)

						GoogleApiInterface.any_instance.should_receive(:authorize_from_code).with("code")
						GoogleApiInterface.any_instance.stub(:current_user_google_id).and_return("123456")
						GoogleApiInterface.any_instance.stub(:current_user_email).and_return("old@email.com")
						GoogleApiInterface.any_instance.stub(:display_name_for_user).with("123456").and_return("New Name")
						GoogleApiInterface.any_instance.stub(:image_url_for_user).with("123456").and_return(nil)
			
						subject
			
						User.where(google_id: "123456").count.should == 1
						user = User.find_by_google_id("123456")
						user.display_name.should == "New Name"
						user.email.should == "old@email.com"
						user.profile_image_url.should be_blank
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