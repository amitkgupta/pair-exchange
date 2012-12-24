require 'spec_helper'

describe "Logging in", js: true do
	it "should redirect to the projects page by default" do
		login_test_user
		page.should have_content "Project"
		page.should have_content "PairExchange"
		page.should have_content "Add project"				
	end
end
	