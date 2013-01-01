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
end