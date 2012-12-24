require 'spec_helper'

describe InterestsController do  
  before do
    fake_login_user
  end

  describe 'routing' do
    specify do
      {post: '/interests'}.should route_to(controller: 'interests', action: 'create')
    end
  end

  describe 'create' do
    let(:project) { create(:project) }
    
    subject do
    	post :create, project_id: project.id
    end

    it 'creates a new interest with the given params' do
      project.interested_users.should be_blank
      fake_logged_in_user.interests.should be_blank
      
      subject
      project.reload
      fake_logged_in_user.reload
      
      project.interested_users.should == [fake_logged_in_user]
      fake_logged_in_user.interests.should == [project]
    end

    it 'redirects to /' do
	  subject
      response.should redirect_to('/projects')
    end
  end
end
