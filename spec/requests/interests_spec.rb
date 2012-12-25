require 'spec_helper'

describe 'Declaring and recanting interest in projects', js: true do
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