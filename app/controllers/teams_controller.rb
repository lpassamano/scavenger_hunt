class TeamsController < ApplicationController
  def show
    @team = Team.find(params[:id])
    @hunt = Hunt.find(params[:hunt_id])
  end
end
