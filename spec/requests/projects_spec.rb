require 'spec_helper'

describe 'Listing projects', js: true do
  before do
	Project.create!(name: 'My Lovely Project')
    Project.create!(name: 'My Done Project', finished: true)
    
 	login_test_user
  end

  it 'shows a list of active projects on the home page' do
    page.should have_content('My Lovely Project')
    page.should_not have_content('My Done Project')
  end

  it 'allows you to create a new project' do
    click_on "Add project"
    within('#new_project') do
      fill_in 'Project Name', with: 'My 8th Grade Science Diorama'
      page.should have_content('testing.pair.exchange@gmail.com')
      select 'SF', from: 'Office'
      fill_in 'Technology', with: 'Cardboard'
      click_on 'Create Project'
    end
    page.should have_content('My 8th Grade Science Diorama')
    current_path.should == projects_path
  end

  it 'allows you to edit a project' do
    click_on 'Edit My Lovely Project'
    fill_in 'Description', with: 'Pairing on Starcraft with Dan Hansen'
    click_on 'Update Project'
    current_path.should == projects_path
  end

  it 'allows you to express interest in a project' do
    click_on "I'm interested in My Lovely Project"
    page.should have_content('You are interested in My Lovely Project')
  end
end