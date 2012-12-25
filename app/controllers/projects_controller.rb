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
    project = Project.find(params[:id])
    
    if project.owner == current_user
      @project = Project.find(params[:id])
      @owner = UserPresenter.new(@project.owner)
    else
	  head 403
    end
  end

  def update
    project = Project.find(params[:id])
    
    if project.owner == current_user
      project.update_attributes(params[:project])
      redirect_to(projects_path)
    else     	
      head 403
    end
  end
  
  def destroy
  	project = Project.find(params[:id])
    
    if project.owner == current_user
      project.destroy
      redirect_to(projects_path)
    else     	
      head 403
    end
  end
end