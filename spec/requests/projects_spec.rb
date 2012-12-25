require 'spec_helper'

describe 'Listing projects', js: true do
  before do
    Project.create(name: 'My Lovely Project', owner: friendly_user, description: 'fun')
    Project.create(name: 'My Lonely Project', owner: loner, technology: 'wot is it?')
    Project.create(name: 'My Done Project', owner: loner, finished: true)
    
 	login_test_user
  end

  it 'shows the names, descriptions, owners, and technologies of active projects on the home page' do
    page.should have_content('My Lovely Project')
    page.should have_content('pear.programming@gmail.com')
    page.should have_content('fun')
    
    page.should have_content('My Lonely Project')
    page.should have_content('o.solo.mioooo@gmail.com')
    page.should have_content('wot is it?')
    
    page.should_not have_content('My Done Project')
  end

  it 'allows you to create a new project' do
    page.should_not have_content('My 8th Grade Science Diorama')
    page.should_not have_content('Jay Pivot')
  
    click_on "Add project"
    
    within('#new_project') do
      fill_in 'Project Name', with: 'My 8th Grade Science Diorama'
      page.should_not have_content('Owned By')
      select 'SF', from: 'Office'
      fill_in 'Technology', with: 'Cardboard'
      click_on 'Create Project'
    end

    current_path.should == projects_path    
    page.should have_content('My 8th Grade Science Diorama')
    page.should have_content('Jay Pivot')
  end

  describe "editing" do
	it 'allows you to edit a project' do
    	page.should have_content('My Lovely Project')
	    page.should_not have_content('Pairing on Starcraft with Dan Hansen')

	    click_on 'Edit My Lovely Project'
    
    	fill_in 'Project Name', with: 'Pairing on Starcraft with Dan Hansen'
	    fill_in 'Description', with: 'OMG ZERG RUSH'
    
    	click_on 'Update Project'
    
	    current_path.should == projects_path
    	page.should_not have_content('My Lovely Project')
	    page.should have_content('Pairing on Starcraft with Dan Hansen')
	end
	  
	it "shows the project owner's display name and photo on the edit form" do
		click_on 'Edit My Lovely Project'
		
		page.should have_content('Owned By')
		page.should have_content('pear.programming@gmail.com')
		page.find('img')['src'].should == "http://localhost:8378/assets/default_google_profile_image.png"
	end
  end
end