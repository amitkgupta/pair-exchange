require 'spec_helper'

describe 'Listing projects', js: true do
  before do
    friendly_user = create(:user, email: 'pear.programming@gmail.com')
    loner = create(:user, email: 'o.solo.mio@gmail.com')
    
    create(:project, name: 'My Lovely Project', owner: friendly_user)
	create(:project, name: 'My Lonely Project', owner: loner)
	create(:project, name: 'My Done Project', finished: true)
    
 	login_test_user
  end
  
  after do
  	visit logout_path
  end

  it 'shows a list of active projects on the home page' do
    page.should have_content('My Lovely Project')
    page.should_not have_content('My Done Project')
  end
  
  it "shows owners' emails beside the projects" do
  	projects_data = page.all('tr')[1..-1].map do |row|
	  {owner_email: row.find('.owner_email').text, project_name: row.find('.project_name').text}
	end
		
	projects_data.should =~ [
	  {owner_email: 'pear.programming@gmail.com', project_name: 'My Lovely Project'},
	  {owner_email: 'o.solo.mio@gmail.com', project_name: 'My Lonely Project'}
	]
  end

  it 'allows you to create a new project' do
    page.should_not have_content('My 8th Grade Science Diorama')
    page.should_not have_content('testing.pair.exchange@gmail.com')
  
    click_on "Add project"
    
    within('#new_project') do
      fill_in 'Project Name', with: 'My 8th Grade Science Diorama'
      page.should have_content('testing.pair.exchange@gmail.com')
      select 'SF', from: 'Office'
      fill_in 'Technology', with: 'Cardboard'
      click_on 'Create Project'
    end

    current_path.should == projects_path    
    page.should have_content('My 8th Grade Science Diorama')
    page.should have_content('testing.pair.exchange@gmail.com')
  end

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

  it 'allows you to express interest in a project' do
    page.should_not have_content('You are interested in My Lovely Project')
  
    click_on "I'm interested in My Lovely Project"
    
    page.should have_content('You are interested in My Lovely Project')
  end
end