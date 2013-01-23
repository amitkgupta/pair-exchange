class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  before_filter :require_current_user

  private

  def require_current_user
    unless current_user.present?
      session[:final_redirect] = request.url
      redirect_to google_api_interface.authorization_uri.to_s
    end
  end
end