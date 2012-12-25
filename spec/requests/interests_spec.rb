require 'spec_helper'

describe 'Expressing interested and disinterest in projects', js: true do
  before do
    Project.create(name: 'My Lovely Project', owner: friendly_user)
    
 	login_test_user
  end

  pending 'allows you to express interest in a project' do
    page.should_not have_content('You are interested in My Lovely Project')
    page.should_not have_content("I'm no longer interested in My Lovely Project")
    page.should have_content("You have not expressed interest in My Lovely Project")
  
    click_on "I'm interested in My Lovely Project"
    
    page.should have_content('You are interested in My Lovely Project')
    page.should have_content("I'm no longer interested in My Lovely Project")
    page.should_not have_content("You have not expressed interest in My Lovely Project")
  end
  
  context 'for a project you are already interested in' do
	before do
	  click_on "I'm interested in My Lovely Project"
	end
	
	pending 'allows you to recant your interest in the project' do
      page.should have_content('You are interested in My Lovely Project')
  
      click_on "I'm no longer interested in My Lovely Project"
    
      page.should have_content('You have not expressed interest in My Lovely Project')
	end
  end
end