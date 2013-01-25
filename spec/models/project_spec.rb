require 'spec_helper'

describe Project do
	describe "accessible attributes" do
		specify do
			described_class.accessible_attributes.to_a.reject{ |attr| attr.blank? }.should =~ [
				"name",
				"owner", 
				"description",
				"office",
				"other_technologies",
				"rails",
				"ios",
				"android",
				"python",
				"java",
				"scala",
				"javascript"
			]
		end
	end
	
	describe "validations" do
		it "validates presence of owner" do
			subject.should have(1).error_on(:owner)
		end
	end
	
	it { should belong_to(:owner) }
	it { should have_and_belong_to_many(:interested_users) }
	
	describe ".create_from_form_details_and_user" do
		it "creates a project from form details and given user as owner" do
			project = described_class.create_from_form_details_and_user(
				{
					name: 'asdf',
	            	office: 'SF',
              		other_technologies: 'Cardboard'
            	},
				friendly_user
			)
			
			project.should be_persisted
			project.name.should == "asdf"
			project.office.should == "SF"
			project.other_technologies.should == "Cardboard"
			project.owner.should == friendly_user
		end
	end
end