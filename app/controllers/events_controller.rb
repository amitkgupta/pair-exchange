class EventsController < ApplicationController
  before_filter :require_admin

  def index
  	@events = Event.all
  end
  
  def new
    @event = Event.new
  end
  
  def create
    Event.create_from_form_details params[:event]
    
    redirect_to events_path
  end

  private
  
  def require_admin
    redirect_to root_path unless admin_logged_in?
  end
end