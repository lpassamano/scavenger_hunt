class TeamsController < ApplicationController
  before_action :require_login

  def show
    @team = Team.find(params[:id])
    @hunt = Hunt.find(params[:hunt_id])
  end

  def update
    @team = Team.find(params[:id])
    @hunt = Hunt.find(params[:hunt_id])
    new_participant = User.find(params[:team][:participant_id])
    @team.participants << new_participant
    redirect_to hunt_team_path(@hunt, @team)
  end

  private

  def team_params
    params.require(:team).permit(:participant)
  end

  def require_login
    return redirect_to root_path unless current_user
  end
end
