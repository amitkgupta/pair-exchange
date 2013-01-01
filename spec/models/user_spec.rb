require 'spec_helper'

describe User do
	describe "accessible attributes" do
		specify do
			described_class.accessible_attributes.to_a.reject{ |attr| attr.blank? }.should =~ [
				"email",
				"google_id", 
				"profile_image_url",
				"display_name"
			]
		end
	end
	
	describe "validations" do
		it "should validate presence of an email" do
			subject.should have(1).error_on(:email)
		end

		it "should validate presence of a google id" do
			subject.should have(1).error_on(:google_id)
		end
		
		it "should validate uniqueness of google id" do
			User.create(google_id: "1", email: "a@a.a")
			User.new(google_id: "1").should have(1).error_on(:google_id)
		end
	end
	
	it { should have_and_belong_to_many(:interests) }
	it { should have_many(:projects) }

	describe "setting the user's google id, display name, email, and image url" do
		subject do
			described_class.create_or_update_from_google_data(google_api_interface)
		end
		
		let(:google_api_interface) do
			google_api_interface = double()
			google_api_interface.stub(:current_user_google_id).and_return("123456")
			google_api_interface.stub(:current_user_email).and_return("foo@bar.com")
			google_api_interface.stub(:display_name_for_user).with("123456").and_return("New Name")
			google_api_interface.stub(:image_url_for_user).with("123456").and_return("foo.com/img.jpg")
			google_api_interface
		end
		
		context "when a user with the current google id already exists" do
			let!(:user) do
				User.create(
					email: "foo@bar.com",
					google_id: "123456",
					display_name: "Old Name"
				)
			end
			
			it "updates the display name, email, and image url" do
				User.where(google_id: "123456").count.should == 1
			
				subject
				
				User.where(google_id: "123456").count.should == 1
				
				user = User.find_by_google_id("123456")
				user.email.should == "foo@bar.com"
				user.display_name.should == "New Name"
				user.profile_image_url.should == "foo.com/img.jpg"
			end
		end
		
		context "when no user exists with the current google id" do
			it "creates a new user and sets the google id, email, display name, and image url" do
				User.where(google_id: "123456").count.should == 0
			
				subject
				
				User.where(google_id: "123456").count.should == 1
				
				user = User.find_by_google_id("123456")
				user.email.should == "foo@bar.com"
				user.display_name.should == "New Name"
				user.profile_image_url.should == "foo.com/img.jpg"
			end
		end
	end
end
