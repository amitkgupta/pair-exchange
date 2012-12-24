require 'spec_helper'

describe Interest do
	describe "create" do
		it "creates an interest link between given user and project" do
			user = create(:user)
			project = create(:project)
			
			project.interested_users.should be_blank
			user.interests.should be_blank
			
			described_class.create(project, user)
			project.reload
			user.reload
			
			project.interested_users.should == [user]
			user.interests.should == [project]
		end
	end
end