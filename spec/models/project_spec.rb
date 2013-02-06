require 'spec_helper'

describe Project do
	describe "accessible attributes" do
		specify do
			described_class.accessible_attributes.to_a.reject{ |attr| attr.blank? }.should =~ [
				"name",
				"owner", 
				"description",
				"location",
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
	it { should have_and_belong_to_many(:events) }
	
	describe ".create_from_form_details_and_user" do
		it "creates a project from form details and given user as owner" do
			project = described_class.create_from_form_details_and_user(
				{
					name: 'asdf',
	            	location: 'SF',
              		other_technologies: 'Cardboard'
            	},
				friendly_user
			)
			
			project.should be_persisted
			project.name.should == "asdf"
			project.location.should == "SF"
			project.other_technologies.should == "Cardboard"
			project.owner.should == friendly_user
		end
	end
	
	describe "#update_schedule_from_form_details" do
		it "should reset the projects' list of events to based on the form details" do
			event_to_be_scheduled = Event.create
			event_to_be_unscheduled = Event.create
			
			project = described_class.create(owner: friendly_user)
			project.events << event_to_be_unscheduled
			project.save!
			
			project.events.should == [event_to_be_unscheduled]
			
			project.update_schedule_from_form_details("event-#{event_to_be_scheduled.id}" => "#{event_to_be_scheduled.id}")
			
			project.events.should == [event_to_be_scheduled]
		end
	end
end
