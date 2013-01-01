require 'spec_helper'

describe 'Interests', js: true do
  describe 'declaring and recanting interest' do
    before do
      Project.create(name: 'My Lovely Project', owner: friendly_user)
    
 	  login_test_user
    end

    it 'allows you to toogle interest in a project' do
	  page.should_not have_css('.recant-interest')
  
  	  page.find('.declare-interest a').click
    
	  page.should_not have_css('.declare-interest')

	  page.find('.recant-interest a').click
    
	  page.should_not have_css('.recant-interest')
	  page.should have_css('.declare-interest')
    end
  end
  
  describe 'listing interested users' do
    it 'shows a list of the interested users for each project' do
      loved_project = Project.create(name: 'they like me, they really like me', owner: friendly_user)
      loved_project.interested_users = [friendly_user, loner]
        
      liked_project = Project.create(name: "drunk programmers think i'm hot", owner: loner)
      liked_project.interested_users = [loner]
    
      login_test_user
	
	  lists_of_interested_users = page.all('.interested-users').map { |cell| cell.text.split(", ") }
	  lists_of_interested_users.map(&:to_set).to_set.should == Set.new([
		Set.new(["o.solo.mioooo@gmail.com"]),
		Set.new(["o.solo.mioooo@gmail.com", "pear.programming@gmail.com"])
	  ])
    end
  end
end
