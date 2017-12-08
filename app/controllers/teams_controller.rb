class TeamsController < ApplicationController
  before_action :require_login
  
  def show
    @team = Team.find(params[:id])
    @hunt = Hunt.find(params[:hunt_id])
  end

  private

  def require_login
    return redirect_to root_path unless current_user
  end
end
