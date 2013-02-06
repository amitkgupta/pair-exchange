require 'spec_helper'

describe "Scheduling events" do
      before do
        Project.create(owner: jay_pivot, name: "My project", location: "SF")
        Project.create(owner: friendly_user, name: "Not my project")
        
        Event.create(location: "SF", date: Date.new(2013, 5, 5), time: "6pm - 9pm")
        Event.create(location: "London", date: Date.new(2013, 5, 5), time: "5pm - 8pm")
        
        login_user
      end

	it "should show a calendar icon next to projects owned by the user" do      
        page.all('.schedule-project').count.should == 1
        
        page.find('.schedule-project a').click
        
        page.should have_content("2013-05-05 in SF, 6pm - 9pm")
        page.should_not have_content("London")
        
#         page.find('.edit-project a').click
# 		        
#         fill_in 'Project Name', with: 'Just got edited'
	end
end
