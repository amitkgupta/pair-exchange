require 'spec_helper'

describe InterestsController do
  let(:current_user_email) { "jpivot@pivotallabs.com" }
  
  before do
    fake_login(current_user_email)
  end

  describe 'routing' do
    specify do
      {post: '/projects/1/interests'}.should route_to(controller: 'interests', action: 'create', project_id: '1')
    end
  end

  describe 'create' do
    let(:project) { FactoryGirl.create :project }
    let(:params) { {project_id: project.id } }

    it 'creates a new interest with the given params' do
      expect do
        post :create, params
      end.to change(Interest, :count).by(1)

      new_interest = Interest.last
      new_interest.user.should == current_user_email
      new_interest.project.should == project
    end

    it 'redirects to /' do
      post :create, params
      response.should redirect_to('/projects')
    end
  end
end
