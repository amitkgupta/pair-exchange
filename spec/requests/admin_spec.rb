require 'spec_helper'

describe "Admin", js: true do
	context "for non-admins" do
		before do
			User.stub(:admin_emails).and_return([])	
		end
		
		it "does not display an admin button" do
			login_test_user
		
			page.should_not have_content("Admin")
		end
		
		it "does not allow direct navigation to the admin section" do
			login_test_user
			
			visit admin_path
			
			current_path.should == root_path
		end
	end
	
	context "for admins" do
		before do
			User.stub(:admin_emails).and_return(["testing.pair.exchange@gmail.com"])
		end
		
		it "displays an admin button taking the user to the admin page" do
			login_test_user
		
			click_on "Admin"
			
			current_path.should == admin_path
		end
		
		pending "allows direct navigation to the admin page" do
			login_test_user
			
			visit admin_path
			
			current_path.should == admin_path
    end

    describe "event schedule" do
      it "allows admin to add an event" do
        pending "displaying a list of created events so the final line passes"
        login_test_user

        click_on "Admin"

        page.should_not have_content("12/31/2013 in Denver")

        fill_in "Date", with: '12/31/2013'
        select 'Denver', from: 'Location'

        click_on "Create Event"

        page.should have_content("12/31/2013 in Denver")
      end
    end
	end
end