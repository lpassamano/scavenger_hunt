class TeamsController < ApplicationController
  before_action :require_login

  def show
    @team = Team.find(params[:id])
    @hunt = Hunt.find(params[:hunt_id])
  end

  def update
    @team = Team.find(params[:id])
    @hunt = Hunt.find(params[:hunt_id])
    
    if params[:team][:participant_id]
      @team.participants << User.find(params[:team][:participant_id])
      redirect_to hunt_team_path(@hunt, @team)
    elsif params[:team][:remove_participant_id]
      @team.participants.delete(params[:team][:remove_participant_id])
      redirect_to root_path
    end
  end

  private

  def team_params
    params.require(:team).permit(:participant_id, :remove_participant_id)
  end

  def require_login
    return redirect_to root_path unless current_user
  end
end
