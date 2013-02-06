require 'spec_helper'

describe Schedule do
	describe "create" do
		it "creates a schedule link between given event and project" do
			user = User.create(email: "foo@bar.com", google_id: "123455")
			project = Project.create(owner: user, location: "SF")
			event = Event.create(location: "SF", date: Date.new(2012, 5, 5))
			
			project.events.should be_blank
			event.projects.should be_blank
			
			described_class.create(project, event)
			project.reload
			event.reload
			
			project.events.should == [event]
			event.projects.should == [project]
		end
	end
end
