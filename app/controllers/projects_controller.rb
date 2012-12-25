require_relative '../presenters/project_presenter.rb'

class ProjectsController < ApplicationController
  def index
    @projects = Project.active.map { |project| ProjectPresenter.new(project) }
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
      @project = ProjectPresenter.new(Project.find(params[:id]))
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
end