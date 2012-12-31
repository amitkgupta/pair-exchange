require 'spec_helper'

describe "Sessions", js: true do
	it "logging in should redirect to project index by default" do
		login_test_user

		page.should have_content "Project"
		page.should have_content "PairExchange"
		page.should have_content "Add project"
	end
	
	it "clicking 'Sign out' should log the user out of the app and Google" do
		login_test_user
		
		page.should have_content "PairExchange"
					
		click_on "Sign out"
				
		page.should_not have_content "PairExchange"
		current_url.should == "https://accounts.google.com/Login"
	end
end