require_relative '../presenters/project_presenter.rb'

class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:owner, :interested_users)
    
    if params[:location]
      @location = params[:location].to_s
      @projects = @projects.where(location: @location)
    end

    @project_presenters = @projects.all.map { |project| ProjectPresenter.new(project, current_user) }
  end

  def show
    @project = ProjectPresenter.new(Project.find(params[:id]), current_user)

    render partial: 'project'
  end

  def new
    @project = Project.new
    @new_project_form = true

    render partial: 'form'
  end

  def create
    @project = ProjectPresenter.new(
      Project.create_from_form_details_and_user params[:project], 
      current_user
    )
    render partial: 'project'    
  end

  def edit
    ensure_access do |project|
      @project = project
      @owner = UserPresenter.new(@project.owner)
      render partial: 'form'
    end
  end

  def update
    ensure_access do |project|
      project.update_attributes(params[:project])
      @project = ProjectPresenter.new(project, current_user)
      
      render partial: 'project'
    end
  end
  
  def destroy
    ensure_access do |project|
      project.destroy
      
      render nothing: true  
    end
  end
  
  def schedule
  	ensure_access do |project|
  	  @project = project
  	  @events = Event.for_location @project.location
  	end
  end
  
  def update_schedule
    ensure_access do |project|
      project.update_schedule_from_form_details params
      
      redirect_to root_path
    end
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
