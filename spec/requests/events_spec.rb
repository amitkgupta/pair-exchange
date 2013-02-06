require 'spec_helper'

describe "Events", js: true do
	context "for non-admins" do
		before do
			User.stub(:admin_emails).and_return([])	
		end
		
		it "does not display an events button" do
			login_user
		
			page.should_not have_content("Events")
		end
		
		it "does not allow direct navigation to the events section" do
			login_user
			
			visit events_path
			
			current_path.should == root_path
		end
	end
	
	context "for admins" do
		before do
			User.stub(:admin_emails).and_return(["testing.pair.exchange@gmail.com"])
		end
		
		it "displays an events button taking the user to the events page" do
			login_user
		
			click_on "Events"
			
			current_path.should == events_path
		end
		
		pending "allows direct navigation to the events page" do
			login_user
			
			visit events_path
			
			current_path.should == events_path
    	end
    	
    	describe "listing events" do
		    before do
		      Event.create(location: "Santa Monica", date: Date.new(1901, 1, 1))
		      Event.create(location: "Boulder", date: Date.new(2011, 11, 11))
		      
		   	  login_user
		    end
    
		    it 'shows the dates and locations of all events' do
				click_on "Events"

				page.should have_content("1901-01-01 in Santa Monica")
				page.should have_content("2011-11-11 in Boulder")
	    	end
	    end
    	
    	describe "creating events" do
    		it "allows admins to create an event" do
		        login_user

        		click_on "Events"

   			    page.should_not have_content("2013-12-31 in Denver, 6pm - 9pm")
   			    
   			    click_on "Add Event"
   			    
		        fill_in "Date", with: '12/31/2013'
        		select 'Denver', from: 'Location'
        		fill_in "Time", with: "6pm - 9pm"

		        click_on "Create Event"

		        page.should have_content("2013-12-31 in Denver, 6pm - 9pm")
    		end
    	end
	end
end