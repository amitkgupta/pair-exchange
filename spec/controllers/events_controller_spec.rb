require 'spec_helper'

describe EventsController do
  describe "routing" do
    specify do
      {get: '/events'}.should route_to(controller: 'events', action: 'index')
    end
  
    specify do
      {get: '/events/new'}.should route_to(controller: 'events', action: 'new')
    end
  
    specify do
      {post: '/events'}.should route_to(controller: 'events', action: 'create')
    end
  end

  describe "actions" do
    describe "when an admin is logged in" do
      before do
        User.stub(:admin_emails).and_return(["pear.programming@gmail.com"])

        fake_login_user
      end
      
      describe "#index" do
        before do
	      Event.create(location: 'London', date: Date.new(2013, 12, 31))
	      Event.create(location: 'Boulder', date: Date.new(2012, 12, 31))
        end

        it 'assigns all the Events' do
          get :index

          assigns(:events).should == Event.all
        end
      end
      
      describe "#new" do
        it 'should assign a new event' do
          get :new

          event = assigns(:event)
          event.should_not be_persisted
          event.should be_an(Event)
        end
      end
      
      describe "#create" do
        it 'creates a new event with the given params' do
          expect do
            post :create, event: { date: '12/31/2013', location: 'London' }
          end.to change(Event, :count).by(1)
          Event.last.date.should == Date.new(2013, 12, 31)
          Event.last.location.should == "London"
        end

        it 'redirects to the index page' do
          post :create, event: { date: '12/31/2013', location: 'London' }
          response.should redirect_to(events_path)
        end
      end
    end
    
    describe "when a non-admin is logged in" do
      before do
        fake_login_user
      end
	  
	  it "should redirect all requests to the root path" do
	    get :index
	    response.should redirect_to(root_path)

	    get :new
	    response.should redirect_to(root_path)

		post :create
	    response.should redirect_to(root_path)	
	  end	    
    end
  end
end