# Controller to handle FB login/signup
class Users::CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(auth)
    sign_in_and_redirect @user
  end

  def auth
    request.env['omniauth.auth']
  end
end
