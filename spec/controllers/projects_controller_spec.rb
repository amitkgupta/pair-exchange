require 'spec_helper'

describe ProjectsController do
  before do
    fake_login_user
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
	  Project.create(name: 'The Alan Parsons Project', owner: friendly_user)
	  Project.create(name: 'Projecting Fear', owner: friendly_user)
	  Project.create(name: 'Astral Projection', owner: friendly_user)
	  Project.create(name: 'A project', owner: friendly_user)
	  Project.create(name: 'A finished project', finished: true, owner: friendly_user)
    end

    it 'assigns all the unfinished Projects' do
      get :index
      assigns(:projects).should == Project.active
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
    let(:project) { Project.create(owner: friendly_user) }

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
            office: 'SF',
            technology: 'Cardboard'
          }
      end.to change(Project, :count).by(1)
      Project.last.name.should == 'asdf'
      Project.last.owner.should == fake_logged_in_user
      Project.last.office.should == 'SF'
      Project.last.technology.should == 'Cardboard'
    end

    it 'redirects to /' do
      post :create, project: {name: 'asdf'}
      response.should redirect_to('/projects')
    end
  end

  describe 'update' do
    let(:project) { Project.create(owner: friendly_user) }
    it 'updates a project with the given params' do
      expect do
        put :update, id: project.to_param, project: {name: 'new name'}
      end.to change(Project, :count).by(1)
      project.reload
      project.name.should == 'new name'
    end

    it 'redirects to /' do
      put :update, id: project.to_param, project: {name: 'new name'}
      response.should redirect_to('/projects')
    end
  end
end