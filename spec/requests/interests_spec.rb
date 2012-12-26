require 'spec_helper'

describe 'Interests', js: true do
  describe 'declaring and recanting interest' do
    before do
      Project.create(name: 'My Lovely Project', owner: friendly_user)
    
 	  login_test_user
    end

    it 'allows you to declare interest in a project' do
      page.should have_css('.declare-interest')
	  page.should_not have_css('.recant-interest')
  
  	  page.find('.declare-interest a').click
    
	  wait_until { page.has_css? '.recant-interest' }
	  page.should_not have_css('.declare-interest')
    end
  
    context 'when you are already interested in a project' do
  	  before do
	    page.find('.declare-interest a').click
	    wait_until { page.has_css? '.recant-interest' }
	  end
	
	  it 'allows you to recant your interest in the project' do
	    page.find('.recant-interest a').click
    
	    wait_until { page.has_css? '.declare-interest' }
	    page.should_not have_css('.recant-interest')
	  end
    end
  end
  
  describe 'listing interested users' do
    it 'shows a list of the interested users for each project' do
      loved_project = Project.create(name: 'they like me, they really like me', owner: friendly_user)
      loved_project.interested_users = [friendly_user, loner]
    
      new_liker = User.create(email: 'foo@bar.com', google_id: '<3', display_name: 'i like projects')
    
      liked_project = Project.create(name: "drunk programmers think i'm hot", owner: loner)
      liked_project.interested_users = [new_liker]
    
      login_test_user
	
	  lists_of_interested_users = page.all('.interested-users').map { |cell| cell.text.split(", ") }
	  lists_of_interested_users.map(&:to_set).to_set.should == Set.new([
		Set.new(["i like projects"]),
		Set.new(["o.solo.mioooo@gmail.com", "pear.programming@gmail.com"])
	  ])
    end
  end
end
