require 'spec_helper'

describe InterestsController do  
  before do
    fake_login_user
  end

  describe 'routing' do
    specify do
      {post: '/interests'}.should route_to(controller: 'interests', action: 'create')
    end
    
    specify do
      {delete: '/interests'}.should route_to(controller: 'interests', action: 'destroy')
    end
  end

  describe '#create' do
    let(:project) { Project.create(owner: friendly_user) }
    
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
  
  describe '#destroy' do
  	let(:project) { Project.create(owner: friendly_user) }
  	
  	subject do
  		delete :destroy, project_id: project.id
  	end
  	
  	it 'destroys the interest between the given project and current user' do
  		Interest.create(project, fake_logged_in_user)  		

		project.interested_users.should == [fake_logged_in_user]
		fake_logged_in_user.interests.should == [project]
		
		subject
		project.reload
		fake_logged_in_user.reload
		
        project.interested_users.should be_blank
        fake_logged_in_user.interests.should be_blank
    end

    it 'redirects to /' do
	  subject
      response.should redirect_to('/projects')
    end
  end		
end
