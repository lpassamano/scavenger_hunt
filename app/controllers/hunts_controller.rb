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
    @locations = Location.all
  end

  def create
    @hunt = Hunt.new(hunt_params)
    @hunt.owner = current_user
    if @hunt.save
      redirect_to hunt_path(@hunt)
    else
      render :new, {alert: @hunt.errors.full_messages}
    end
  end

  private

  def require_login
    return redirect_to root_path unless current_user
  end

  def hunt_params
    params.require(:hunt).permit(
      :name,
      :start_time,
      :finish_time,
      location_attributes: [
        :city,
        :state
      ],
      items_attributes: [
        :name
      ]
    )
  end
end
