class Users::CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # create User.from_omniauth(auth)
    @user = User.from_omniauth(auth)
    sign_in_and_redirect @user
    #render 'welcome/index'
  end

  def auth
    request.env['omniauth.auth']
  end
end
