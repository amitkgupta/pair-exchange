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
    @project = ProjectPresenter.new(Project.find(params[:id]))
  end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes(params[:project])
    redirect_to(projects_path)
  end
end