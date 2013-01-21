require 'spec_helper'

describe AdminController do
  describe 'routing' do
    specify do
      {get: '/admin'}.should route_to(controller: 'admin', action: 'calendar')
    end
  end
  
  describe 'actions' do
    describe '#calendar' do
      context "when a non-admin is logged in" do
        before do
 	      fake_login_user
        end       
      
        it 'redirects to the root path' do
          get :calendar
        
          response.should redirect_to(root_path)
        end
	  end

      context "when an admin is logged in" do
        before do
          User.stub(:admin_emails).and_return(["pear.programming@gmail.com"])

        
          fake_login_user
        end
        
        it "should not redirect the user away" do
          get :calendar
          
          
		  response.should_not be_redirect
		  response.status.should == 200
        end
      end
    end
  end
end
