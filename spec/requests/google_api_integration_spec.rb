require 'spec_helper'

describe 'Google API Integration', js: true do
	context "when the owner doesn't have a Google+ profile" do
		it "displays the default image and the user's email next to their projects" do
			Project.create(name: 'The Projective Hierarchy', owner: friendly_user)
	
			login_test_user
		
			source = page.all('tr')[1].find('img')['src']
			source.should == "http://localhost:8378/assets/default_google_profile_image.png"
			page.all('tr')[1].find('.display-name').text.should == "pear.programming@gmail.com"
		end
	end
		
	context "when the owner does have a Google+ profile" do
		it "displays the users Google+ pictures and display name next to their projects" do
			login_test_user
				
			click_on "Add project"
    
		    within('#new_project') do
		    	click_on 'Create Project'
			end
			    
		    source = page.all('tr')[1].find('img')['src']
		    source.should include('https://lh6.googleusercontent.com/')
			source.should include('/photo.jpg?sz=50')
			page.all('tr')[1].find('.display-name').text.should == "Jay Pivot"
		end
	end
end