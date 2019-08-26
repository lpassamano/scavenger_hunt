# Controller for user routes
class UsersController < ApplicationController
  before_action :require_login
  before_action  :require_profile_ownership, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_profile_path(@user)
    else
      render :edit
    end
  end

  private

  def require_profile_ownership
    user = User.find(params[:id])
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
