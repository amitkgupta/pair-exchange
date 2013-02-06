require_relative '../presenters/project_presenter.rb'

class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:owner, :interested_users)
    if params[:location]
      @location = params[:location].to_s
      @projects = @projects.where(location: @location)
    end

    @project_presenters = @projects.all.map do |project|
      ProjectPresenter.new(project, current_user)
    end
  end

  def new
    @project = Project.new
  end

  def create
    Project.create_from_form_details_and_user params[:project], current_user
    
    redirect_to root_path
  end

  def edit
    ensure_access do |project|
      @project = project
      @owner = UserPresenter.new(@project.owner)
    end
  end

  def update
    ensure_access do |project|
      project.update_attributes(params[:project])
      redirect_to root_path
    end
  end
  
  def destroy
    ensure_access do |project|
      project.destroy
      redirect_to root_path
    end
  end
  
  def schedule
  	@events = Event.for_location Project.find(params[:id]).location
  end
  
  private
  
  def ensure_access
  	project = Project.find(params[:id])
  	
  	if project.owner == current_user
  	  yield(project) 
  	else 
  	  head 403
  	end
  end
end
