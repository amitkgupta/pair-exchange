require 'spec_helper'

describe EventsController do
  describe "routing" do
    specify do
      {post: '/events'}.should route_to(controller: 'events', action: 'create')
    end
  end

  describe "actions" do
    describe "#create" do
      before do
        fake_login_user
      end

      it 'creates a new event with the given params' do
        expect do
          post :create, event: { date: '12/31/2013', location: 'London' }
        end.to change(Event, :count).by(1)
        Event.last.date.should == Date.new(2013, 12, 31)
        Event.last.location.should == "London"
      end

      it 'redirects to the admin page' do
        post :create, event: { date: '12/31/2013', location: 'London' }
        response.should redirect_to(admin_path)
      end
    end
  end
end