require 'spec_helper'

describe ProjectsController do
  describe 'routing' do
    specify do
      {get: '/projects'}.should route_to(controller: 'projects', action: 'index')
    end

    specify do
      {get: '/projects/new'}.should route_to(controller: 'projects', action: 'new')
    end

    specify do
      {post: '/projects'}.should route_to(controller: 'projects', action: 'create')
    end
  end

  describe '#index' do
    before do
      Project.create(name: 'The Alan Parsons Project')
      Project.create(name: 'Projecting Fear')
      Project.create(name: 'Astral Projection')
      Project.create(name: 'A project')
    end

    it 'assigns all the Projects' do
      get :index
      assigns(:projects).should == Project.all
    end
  end

  describe 'new' do
    it 'assigns a new Project' do
      get :new
      project = assigns(:project)
      project.should_not be_persisted
      project.should be_a(Project)
    end
  end

  describe 'create' do
    it 'creates a new project with the given params' do
      expect do
        post :create, project: {name: 'asdf', owner: 'zxcv'}
      end.to change(Project, :count).by(1)
      Project.last.name.should == 'asdf'
      Project.last.owner.should == 'zxcv'
    end

    it 'redirects to /' do
      post :create, project: {name: 'asdf', owner: 'zxcv'}
      response.should redirect_to('/projects')
    end
  end
end