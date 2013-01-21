class AdminController < ApplicationController
  before_filter :require_admin

  def calendar
  end
  
  private
  
  def require_admin
    redirect_to root_path unless admin_logged_in?
  end
end
