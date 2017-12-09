class UsersController < ApplicationController
  before_action :require_login

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    require_current_user_to_be(@user)
  end

  def update
    require_current_user_to_be(@user)
  end

  private

  def require_current_user_to_be(user)
    return redirect_to root_path unless current_user == user
  end
end
