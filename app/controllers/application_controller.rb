class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || !!current_user.name ? root_path : edit_user_path(current_user)
  end

  def require_login
    return redirect_to root_path unless current_user
  end
end
