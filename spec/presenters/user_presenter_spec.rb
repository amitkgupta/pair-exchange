require 'spec_helper'

describe UserPresenter do
	context "when the user has a display name and image url" do
		let(:user) do 
			User.new(
				email: "an@lo.com",
				display_name: "An Lo",
				profile_image_url: "foo.com/img.jpg"
			)
		end
		
		it "should have the user's display name and image url as attributes" do
			user_presenter = described_class.new(user)
			user_presenter.display_name.should == "An Lo"
			user_presenter.profile_image_url.should == "foo.com/img.jpg"
		end
	end
	
	context "when the user doesn't have a display name" do
		let(:user) { User.new(email: "an@lo.com") }
		
		it "defaults to using the user's email address" do
			described_class.new(user).display_name.should == "an@lo.com"
		end
	end
	
	context "when the user doesn't have a profile image url" do
		let(:user) { User.new }
		
		it "defaults to the Google default" do
			described_class.new(user).profile_image_url.should == "http://localhost:8378/assets/default_google_profile_image.png"
		end
	end
end