# Controller for user routes
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
    @user = User.find(params[:id])
    require_current_user_to_be(@user)
    if @user.update(user_params)
      redirect_to user_profile_path(@user)
    else
      render :edit
    end
  end

  private

  def require_current_user_to_be(user)
    return redirect_to root_path unless current_user == user
  end

  def user_params
    params.require(:user).permit(
      :name,
      location_attributes: [
        :city,
        :state
      ]
    )
  end
end
