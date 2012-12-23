require 'spec_helper'

describe 'Listing projects' do
  let(:user) { 'jpivot@pivotallabs.com' }

  before do
    visit "#{test_login_path}?email=#{user}"
    Project.create!(name: 'My Lovely Project')
    Project.create!(name: 'My Done Project', finished: true)
    
    visit root_path
  end

  it 'shows a list of added projects on the home page' do
    page.should have_content('My Lovely Project')
    page.should_not have_content('My Done Project')
  end

  it 'allows you to create a new project' do
    click_on "Add project"
    within('#new_project') do
      fill_in 'Project Name', with: 'My 8th Grade Science Diorama'
      page.should have_content(user)
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