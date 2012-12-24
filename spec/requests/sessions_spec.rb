require 'spec_helper'

describe "Logging in", js: true do
	it "redirects to the root path by default" do
		login_test_user

		page.should have_content "Project"
		page.should have_content "PairExchange"
		page.should have_content "Add project"
	end
end

describe "Logging out", js: true do
	it "takes the user out of the app" do
		login_test_user
		
		page.should have_content "PairExchange"
		
		click_on "Sign out"
				
		page.should_not have_content "PairExchange"
	end
end