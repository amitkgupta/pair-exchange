require 'spec_helper'

describe "Sessions", js: true do
	it "logging in should redirect to project index by default" do
		login_test_user

		page.should have_content "Project"
		page.should have_content "PairExchange"
		page.should have_content "Add project"
	end
end