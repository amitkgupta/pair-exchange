require_relative '../presenters/project_presenter.rb'

class ProjectsController < ApplicationController
  def index
    @projects = Project.all.map { |project| ProjectPresenter.new(project, current_user) }
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(params[:project])
    project.owner = current_user
    project.save!
    redirect_to(projects_path)
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
      redirect_to(projects_path)
    end
  end
  
  def destroy
    ensure_access do |project|
      project.destroy
      redirect_to(projects_path)
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