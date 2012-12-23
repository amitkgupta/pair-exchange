require 'spec_helper'

describe "Logging in", js: true do
	before do
		WebMock.allow_net_connect!
	end
	
	after do
    	WebMock.disable_net_connect! :allow => %r{/((__.+__)|(hub/session.*))$}
	end
	
	it "should redirect to the projects page by default" do
		visit root_path
		fill_in "Email", with: "testing.pair.exchange@gmail.com"
		fill_in "Password", with: "john50buttons"
		click_on "Sign in"
		if page.has_content? "Allow access"
			sleep 3
			click_on "Allow access" if page.has_content? "Allow access"
		end
		page.should have_content "Project"
		page.should have_content "PairExchange"
		page.should have_content "Add project"				
	end
		
	it "should successfully display users' Google+ pictures"
end
	