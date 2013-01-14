require 'spec_helper'

describe 'Projects', js: true do
  describe 'listing the projects' do
    before do
      Project.create(name: 'My Lovely Project', owner: friendly_user, description: 'fun', scala: true)
      Project.create(name: 'My Lonely Project', owner: loner, other_technologies: 'wot is it?', office: 'SF', ios: true)
    
   	  login_test_user
    end
    
    it 'shows the names, descriptions, owners, office, and other technologies of all projects' do
      within("h3") { page.should have_content("Projects for All Offices") }

      lovely_project_row = page.all('tr').find { |row| row.has_content? 'My Lovely Project' }
      lovely_project_row.should be_present
      lovely_project_row.should have_content('pear.programming@gmail.com')
      lovely_project_row.should have_content('fun')
    	
      lonely_project_row = page.all('tr').find { |row| row.has_content? 'My Lonely Project' }
      lonely_project_row.should be_present
      lonely_project_row.should have_content('o.solo.mioooo@gmail.com')
      lonely_project_row.should have_content('wot is it?')
      lonely_project_row.should have_content('SF')
    end

    it "filters by office" do
      within("#office-filter") do
        click_on "By Office"
        click_on "SF"
      end

      within("h3") { page.should have_content("Projects for SF Office") }

      lovely_project_row = page.all('tr').find { |row| row.has_content? 'My Lovely Project' }
      lovely_project_row.should_not be_present

      lonely_project_row = page.all('tr').find { |row| row.has_content? 'My Lonely Project' }
      lonely_project_row.should be_present
    end

    it 'shows the appropriate technology icons' do      
      page.should have_xpath("//img[@src=\"/assets/android-icon-grey.png\"][@title=\"Android\"]", count: 2)
      page.should_not have_xpath("//img[@src=\"/assets/android-icon.png\"]")

      page.should have_xpath("//img[@src=\"/assets/rails-icon-grey.png\"]", count: 2)
      page.should_not have_xpath("//img[@src=\"/assets/rails-icon.png\"]")      

      page.should have_xpath("//img[@src=\"/assets/javascript-icon-grey.png\"]", count: 2)
      page.should_not have_xpath("//img[@src=\"/assets/javascript-icon.png\"]")      

      page.should have_xpath("//img[@src=\"/assets/python-icon-grey.png\"]", count: 2)
      page.should_not have_xpath("//img[@src=\"/assets/python-icon.png\"]")      

      page.should have_xpath("//img[@src=\"/assets/java-icon-grey.png\"]", count: 2)
      page.should_not have_xpath("//img[@src=\"/assets/java-icon.png\"]")      

      page.should have_xpath("//img[@src=\"/assets/scala-icon-grey.png\"]", count: 1)
      page.should have_xpath("//img[@src=\"/assets/scala-icon.png\"]", count: 1)      

      page.should have_xpath("//img[@src=\"/assets/apple-icon-grey.png\"]", count: 1)
      page.should have_xpath("//img[@src=\"/assets/apple-icon.png\"]", count: 1)      
    end
  end

  describe 'adding a project' do
    it 'allows you to add a project' do
      login_test_user
    
      page.should_not have_content('My 8th Grade Science Diorama')
      page.should_not have_content('Jay Pivot')
  
      click_on "Add project"
    
      within('#new_project') do
        fill_in 'Project Name', with: 'My 8th Grade Science Diorama'
        page.should_not have_content('Owned By')
        select 'SF', from: 'Office'
        fill_in 'Other technologies', with: 'Cardboard'
		page.find('#scala-checkbox-container').click
        click_on 'Create Project'
      end
      
      current_path.should == root_path    
      page.should have_content('My 8th Grade Science Diorama')
      page.should have_content('Jay Pivot')
      page.should have_xpath("//img[@src=\"/assets/scala-icon.png\"]")
      page.should_not have_xpath("//img[@src=\"/assets/scala-icon-grey.png\"]")
    end
  end
  
  describe 'editing a project' do
    context 'when the current user owns the project' do
      before do
        Project.create(owner: test_user, name: "New project, about to be edited", scala: true)
        
        login_test_user
      end
      
      it 'allows the user to edit it' do
        page.should have_content('New project, about to be edited')
        page.all('.edit-project').count.should == 1
        
        page.find('.edit-project a').click
		        
        fill_in 'Project Name', with: 'Just got edited'
		page.find('#scala-checkbox-container').click
        click_on 'Update Project'
        
        current_path.should == root_path
        page.should have_content('Just got edited')
        page.should_not have_content('New Project, about to be edited')
        page.should_not have_xpath("//img[@src=\"/assets/scala-icon.png\"]")
        page.should have_xpath("//img[@src=\"/assets/scala-icon-grey.png\"]")        
      end
    end
    
    context 'when the current user does not own the project' do
      before do
        Project.create(name: "someone else's project", owner: loner)
    
   	    login_test_user
      end
      
      it "doesn't allow the user to edit" do
      	all('.edit-project').count.should == 0
      end
    end
  end
  
  describe 'destroying a project' do
    context 'when the current user owns the project' do
      before do
        Project.create(owner: test_user, name: "New project, about to be deleted")

        login_test_user
      end
      
      it 'allows the user to delete it' do
        page.should have_content 'New project, about to be deleted'
        page.all('.torch-project').count.should == 1
        
        page.find('.torch-project').click
        
        current_path.should == root_path
        wait_until { page.has_no_content? 'New project, about to be deleted' }
      end
    end
    
    context 'when the current user does not own the project' do
      before do
        Project.create(name: "someone else's project", owner: loner)
    
   	    login_test_user
      end

      it "doesn't allow the user to delete" do
      	all('.torch-project').count.should == 0
      end
    end
  end
end
