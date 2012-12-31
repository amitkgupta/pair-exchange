require 'spec_helper'

describe "Sessions", js: true do
	it "logging in should redirect to project index by default" do
		login_test_user

		page.should have_content "Project"
		page.should have_content "PairExchange"
		page.should have_content "Add project"
	end
	
	it "clicking 'Sign out' should log the user out of the app and Google and return to the sign in page" do
		login_test_user
		
		page.should have_content "PairExchange"
					
		click_on "Sign out"
				
		page.should_not have_content "PairExchange"
		page.should have_content "Sign in"
		page.should have_content "Email"
		page.should have_content "Password"		
	end
end