require 'spec_helper'

describe 'Google API Integration', js: true do
	describe "profile pictures of owners next to projects" do
		context "when the owner doesn't have a G+ profile picture" do
			it "displays the default" do
				Project.create(name: 'The Projective Hierarchy', owner: friendly_user)
	
				login_test_user
		
				source = page.all('tr')[1].find('img')['src']
				source.should == "http://localhost:8378/assets/default_google_profile_image.png"
			end
		end
		
		context "when the owner does have a G+ profile picture" do
			it "displays the G+ picture next to the project" do
				login_test_user
				
				click_on "Add project"
    
			    within('#new_project') do
      				fill_in 'Project Name', with: 'Orthogonal Projections'
			    	click_on 'Create Project'
			    end
			    
			    source = page.all('tr')[1].find('img')['src']
			    source.should include('https://lh6.googleusercontent.com/')
				source.should include('/photo.jpg?sz=50')
			end
		end
	end
end