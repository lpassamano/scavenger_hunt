class SessionsController < ApplicationController
  def create
    # create User.from_facebook(auth) 
    @user = User.find_or_create_by(uid: auth['uid']) do |u|
      u.email = auth['info']['email']
    end

    session[:user_id] = @user.id
    render 'welcome/index'
  end

  def auth
    request.env['omniauth.auth']
  end
end
