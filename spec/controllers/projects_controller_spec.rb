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

    specify do
      {get: '/projects/1/edit'}.should route_to(controller: 'projects', action: 'edit', id: '1')
    end

    specify do
      {put: '/projects/1'}.should route_to(controller: 'projects', action: 'update', id: '1')
    end
    
    specify do
      {delete: '/projects/1'}.should route_to(controller: 'projects', action: 'destroy', id: '1')
    end   
    
    specify do
      {get: '/projects/1/schedule'}.should route_to(controller: 'projects', action: 'schedule', id: '1')
    end 
    
    specify do
      {put: '/projects/1/update_schedule'}.should route_to(controller: 'projects', action: 'update_schedule', id: '1')
    end
  end
  
  describe 'actions' do
    before do
	  fake_login_user
    end

    describe '#index' do
      before do
	    Project.create(name: 'The Alan Parsons Project', owner: friendly_user)
	    Project.create(name: 'Projecting Fear', owner: friendly_user)
  	    Project.create(name: 'Astral Projection', owner: friendly_user)
      end

      it 'presents all the Projects' do
        get :index
        assigns(:projects).should == Project.all
        assigns(:project_presenters).each{ |project| project.should be_a(ProjectPresenter) }
        assigns(:location).should be_nil
      end

      context "with an location filter parameter" do
        it "should only show projects for that location" do
          get :index, location: "NY"
          assigns(:projects).should == Project.where(location: "NY")
          assigns(:location).should == "NY"
        end
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
      context 'when the project belongs to the logged in user' do
        it 'assigns the project and owner' do
          get :edit, id: Project.create(owner: fake_logged_in_user).to_param
          assigns(:project).should be_a(Project)
          assigns(:owner).should be_a(UserPresenter)
        end
      end
      
      context 'when the project does not belong to the logged in user' do
        before do
      	  fake_logged_in_user.should_not == loner
      	
          get :edit, id: Project.create(owner: loner).to_param
        end
      
        it 'forbids the request' do
          response.status.should == 403
        end
      
        it 'does not assign the project' do
          assigns(:project).should be_blank
        end
      end
    end

    describe 'create' do
      it 'creates a new project with the given params' do
        expect do
          post :create, project:
            { name: 'asdf',
              location: 'SF',
              other_technologies: 'Cardboard'
            }
        end.to change(Project, :count).by(1)
        Project.last.name.should == 'asdf'
        Project.last.owner.should == fake_logged_in_user
        Project.last.location.should == 'SF'
        Project.last.other_technologies.should == 'Cardboard'
      end

      it 'redirects to /' do
        post :create, project: {name: 'asdf'}
        response.should redirect_to(root_path)
      end
    end

    describe 'update' do
      context 'when the project belongs to the logged in user' do
	    let!(:project) { Project.create(owner: fake_logged_in_user) }
	   
        it 'updates a project with the given params' do
          expect do
            put :update, id: project.to_param, project: {name: 'new name'}
          end.to change(Project, :count).by(0)
 
          project.reload.name.should == 'new name'
        end

        it 'redirects to /' do
          put :update, id: project.to_param, project: {name: 'new name'}

          response.should redirect_to(root_path)
        end
      end
    
      context 'when the project does not belong to the logged in user' do
        it 'forbids the request' do
          fake_logged_in_user.should_not == loner
      
      	  put :update, id: Project.create(owner: loner).to_param, project: {name: 'new'}
      
          response.status.should == 403
        end
	  end
    end  
  
    describe 'destroy' do
      context 'when the project belongs to the logged in user' do
	    let!(:project) { Project.create(owner: fake_logged_in_user) }
	  
        it 'deletes the project' do
          expect do
            delete :destroy, id: project.to_param
          end.to change(Project, :count).by(-1)
  	    end

        it 'redirects to /' do
          delete :destroy, id: project.to_param
        
          response.should redirect_to(root_path)
        end
      end
    
      context 'when the project does not belong to the logged in user' do
        it 'forbids the request' do
          fake_logged_in_user.should_not == loner
          project = Project.create(owner: loner)
      
          delete :destroy, id: project.to_param
      
          response.status.should == 403
          project.reload.should be_present
        end
  	  end
    end
    
    describe 'schedule' do
      context "when the project belongs to the logged in user" do        
        let!(:project) { Project.create(owner: fake_logged_in_user, location: "Santa Monica") }
        let!(:sf_event) { Event.create(location: "SF") }
        let!(:santa_monica_event) { Event.create(location: "Santa Monica") }

        it 'lists all the events for the same location as the project' do
          get :schedule, id: project.id
        
          assigns(:project).should == project
          assigns(:events).should == [santa_monica_event]	
        end
      end
  
      context "when the project does not belong to the logged in user" do
        it 'forbids the request' do
          fake_logged_in_user.should_not == loner
          project = Project.create(owner: loner)
          
          get :schedule, id: project.id
          
          response.status.should == 403
        end
      end
    end
      
    describe 'update_schedule' do
      context 'when the project belongs to the logged in user' do
  	    let(:project) { Project.create(owner: fake_logged_in_user) }
	    let(:event_to_be_unscheduled) { Event.create }
	    let(:event_to_be_scheduled) { Event.create }
	    
	    before do
	      project.events << event_to_be_unscheduled
	      project.save!
	    end
	   
        it "updates adds the event to the projects' events" do
          project.events.should == [event_to_be_unscheduled]
        
          put :update_schedule, id: project.id, "event-#{event_to_be_scheduled.id}" => "#{event_to_be_scheduled.id}"
 
          project.reload.events.should == [event_to_be_scheduled]
        end

        it 'redirects to /' do
          put :update_schedule, id: project.id

          response.should redirect_to(root_path)
        end
      end
    
      context 'when the project does not belong to the logged in user' do
        it 'forbids the request' do
          fake_logged_in_user.should_not == loner
          project = Project.create(owner: loner)

      	  put :update_schedule, id: project.id
      
          response.status.should == 403
        end
	  end
    end
  end
end
