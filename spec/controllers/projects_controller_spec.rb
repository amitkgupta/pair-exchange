require 'spec_helper'

describe ProjectsController do
  before do
    fake_login("jpivot@pivotallabs.com")
  end

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

    specify do
      {get: '/projects/1/edit'}.should route_to(controller: 'projects', action: 'edit', id: '1')
    end

    specify do
      {put: '/projects/1'}.should route_to(controller: 'projects', action: 'update', id: '1')
    end
  end

  describe '#index' do
    before do
      Project.create(name: 'The Alan Parsons Project')
      Project.create(name: 'Projecting Fear')
      Project.create(name: 'Astral Projection')
      Project.create(name: 'A project')
      Project.create(name: 'A finished project', finished: true)
    end

    it 'assigns all the unfinished Projects' do
      get :index
      assigns(:projects).should == Project.where(:finished => false)
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

  describe 'edit' do
    let(:project) { create(:project) }

    it 'assigns the Project' do
      get :edit, id: project.to_param
      project = assigns(:project)
      project.should be_persisted
      project.should be_a(Project)
    end
  end

  describe 'create' do
    it 'creates a new project with the given params' do
      expect do
        post :create, project:
          { name: 'asdf',
            owner: 'zxcv',
            office: 'SF',
            technology: 'Cardboard'
          }
      end.to change(Project, :count).by(1)
      Project.last.name.should == 'asdf'
      Project.last.owner.should == 'zxcv'
      Project.last.office.should == 'SF'
      Project.last.technology.should == 'Cardboard'
    end

    it 'redirects to /' do
      post :create, project: {name: 'asdf', owner: 'zxcv'}
      response.should redirect_to('/projects')
    end
  end

  describe 'update' do
    let(:project) { create(:project) }
    it 'updates a project with the given params' do
      expect do
        put :update, id: project.to_param, project: {name: 'asdf', owner: 'zxcv'}
      end.to change(Project, :count).by(1)
      project.reload
      project.name.should == 'asdf'
      project.owner.should == 'zxcv'
    end

    it 'redirects to /' do
      put :update, id: project.to_param, project: {name: 'asdf', owner: 'zxcv'}
      response.should redirect_to('/projects')
    end
  end
end