class TeamsController < ApplicationController
  before_action :require_login

  def show
    @team = Team.find(params[:id])
    @hunt = Hunt.find(params[:hunt_id])
  end

  def new
    @hunt = Hunt.find(params[:hunt_id])
    @team = @hunt.teams.build(name: "")
    check_hunt_status(@hunt)
  end

  def create
    @hunt = Hunt.find(params[:hunt_id])
    @team = @hunt.teams.build(new_team_params)
    check_hunt_status(@hunt)
    if @team.add_participant(current_user)
      @hunt.save
      redirect_to hunt_team_path(@hunt, @team)
    else
      redirect_to hunt_path(@hunt), { alert: "You can't create a team because you are already in a team for this hunt!"}
    end
  end

  def update
    @team = Team.find(params[:id])
    @hunt = Hunt.find(params[:hunt_id])

    if params[:team][:participant_id]
      @team.participants << User.find(params[:team][:participant_id])
      redirect_to hunt_team_path(@hunt, @team)
    elsif params[:team][:remove_participant_id]
      @team.participants.delete(params[:team][:remove_participant_id])
      if @team.participants == []
        @team.destroy
      end
      redirect_to root_path
    end
  end

  private

  def team_params
    params.require(:team).permit(:participant_id, :remove_participant_id)
  end

  def new_team_params
    params.require(:team).permit(:name)
  end

  def check_hunt_status(hunt)
    return redirect_to hunt_path(hunt), { alert: "You can't add a team after the hunt has started!"} if hunt.active? || hunt.completed?
  end
end
