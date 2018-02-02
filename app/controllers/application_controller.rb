# Controller for login and controllers functionality
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    current_user.name.nil? ? edit_user_profile_path(current_user) : root_path
  end

  def after_sign_up_path_for(resource)
    current_user.name.nil? ? edit_user_profile_path(current_user) : root_path
  end

  def require_login
    return redirect_to root_path unless current_user
  end
end
