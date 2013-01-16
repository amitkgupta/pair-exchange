require 'spec_helper'

describe "Admin", js: true do
	it "does not display an admin button for a non-admin user" do
		User.stub(:admin_emails).and_return([])	
	
		login_test_user
		
		page.should_not have_content("Admin")
	end
	
	it "displays an admin button if user is an admin" do
		User.stub(:admin_emails).and_return(["testing.pair.exchange@gmail.com"])
	
		login_test_user
		
		page.should have_content("Admin")
	end
	
end