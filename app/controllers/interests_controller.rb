class InterestsController < ApplicationController
  def create
    Interest.create(Project.find(params[:project_id]), current_user)
    
    redirect_to(projects_path)
  end
end
