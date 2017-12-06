class HuntsController < ApplicationController
  before_action :require_login

  def index
    @locations = Location.all
    if !params[:location].blank?
      @hunts = Hunt.pending_in(params[:location])
    else
      @hunts = Hunt.pending
    end
    render :index
  end

  def show
    @hunt = Hunt.find(params[:id])
    render :show
  end

  def new
    @hunt = Hunt.new
    @location = Location.new
    @locations = Location.all 
  end

  def create

  end

  private

  def require_login
    return redirect_to root_path unless current_user
  end
end
