require 'spec_helper'

describe "Scheduling events" do
  before do
    Project.create(owner: jay_pivot, name: "My project", location: "SF")
    Project.create(owner: friendly_user, name: "Not my project")
        
    (1..3).each { |n| Event.create(location: "SF", date: Date.new(2013, n, n), time: "6pm - 9pm") }
    Event.create(location: "London", date: Date.new(2013, 5, 5), time: "5pm - 8pm")
        
    login_user
  end

  it "project owner sees a calendar icon linking to a list of events for the same office" do      
    page.all('.schedule-project').count.should == 1
        
    page.find('.schedule-project').click
        
    (1..3).each { |n| page.should have_content("2013-0#{n}-0#{n} in SF, 6pm - 9pm") }
    page.should_not have_content("London")
  end

  it "project owner can schedule a project for a selection of the listed events" do
	page.find('.schedule-project').click
		
	all('input[type=checkbox]').each { |checkbox| checkbox.checked?.should be_nil }
		
	check '2013-01-01 in SF, 6pm - 9pm'
	check '2013-03-03 in SF, 6pm - 9pm'

	click_on 'Update schedule for this project'
		
	page.find('.schedule-project').click
		
	unchecked_box = all('input[type=checkbox]').find do |checkbox|
	  checkbox.value == Event.find_by_date(Date.new(2013, 2, 2)).to_param
	end
		
	checked_boxes = all('input[type=checkbox]').reject do |checkbox|
	  checkbox.value == Event.find_by_date(Date.new(2013, 2, 2)).to_param
	end
		
	unchecked_box.checked?.should be_nil
	unchecked_box.should be_present
	checked_boxes.count.should == 2
	checked_boxes.each { |checkbox| checkbox.checked?.should == "checked" }
  end
end
