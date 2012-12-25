require 'spec_helper'

describe 'Projects', js: true do
  before do
    Project.create(name: 'My Lovely Project', owner: friendly_user, description: 'fun')
    Project.create(name: 'My Lonely Project', owner: loner, technology: 'wot is it?', office: 'SF')
    
 	login_test_user
  end

  describe 'listing the projects' do
    it 'shows the names, descriptions, owners, office, and technologies of active projects on the home page' do
      page.should have_content('My Lovely Project')
      page.should have_content('pear.programming@gmail.com')
      page.should have_content('fun')
    	
      page.should have_content('My Lonely Project')
      page.should have_content('o.solo.mioooo@gmail.com')
      page.should have_content('wot is it?')
      page.should have_content('SF')
    end
  end

  describe 'adding a project' do
    it 'allows you to add a project' do
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
  end
  
  describe 'editing a project' do
    context 'when the current user owns the project' do
      before do
        click_on "Add project"
        fill_in 'Project Name', with: 'New project, about to be edited'
        click_on 'Create Project'
      end
      
      it 'allows the user to edit it' do
        page.all('.edit-project').count.should == 1
        page.find('.edit-project a').click
		        
        fill_in 'Project Name', with: 'Just got edited'
        click_on 'Update Project'
        
        current_path.should == projects_path
        page.should have_content('Just got edited')
        page.should_not have_content('New Project, about to be edited')
      end
    end
    
    context 'when the current user does not own the project' do
      it "doesn't allow the user to edit" do
      	all('.edit-project').count.should == 0
      end
    end
  end
  
  describe 'destroying a project' do
    context 'when the current user owns the project' do
      before do
        click_on "Add project"
        fill_in 'Project Name', with: 'New project, about to be deleted'
        click_on 'Create Project'
        
        current_path.should == projects_path
        page.should have_content 'New project, about to be deleted'
      end
      
      it 'allows the user to delete it' do
        page.all('.torch-project').count.should == 1
        page.find('.torch-project').click
        
        current_path.should == projects_path
        wait_until { !page.has_no_content? 'New project, about to be deleted' }
      end
    end
    
    context 'when the current user does not own the project' do
      it "doesn't allow the user to edit" do
      	all('.torch-project').count.should == 0
      end
    end
  end
end