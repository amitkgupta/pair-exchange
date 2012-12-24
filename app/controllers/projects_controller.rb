class ProjectsController < ApplicationController
  def index
    @projects = Project.active
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
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes(params[:project])
    redirect_to(projects_path)
  end
end