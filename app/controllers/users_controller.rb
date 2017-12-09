class UsersController < ApplicationController
  before_action :require_login

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
  end
end
