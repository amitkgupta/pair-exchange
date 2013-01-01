class InterestsController < ApplicationController
  def create
    Interest.create(Project.find(params[:project_id]), current_user)
    
    redirect_to root_path
  end
  
  def destroy
    Interest.destroy(Project.find(params[:project_id]), current_user)
    
    redirect_to root_path
  end
end
