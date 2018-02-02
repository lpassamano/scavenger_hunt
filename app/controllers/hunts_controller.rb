# controller for hunt routes
class HuntsController < ApplicationController
  before_action :require_login

  def index
    @locations = Location.all
    if !params[:location].blank?
      # if location is given in params
      # show only the pending hunts in that location
      @hunts = Hunt.pending_in(params[:location]).sort_by(&:start_time)
    else
      @hunts = Hunt.pending.sort_by(&:start_time)
    end
    render :index
  end

  def show
    @hunt = Hunt.find(params[:id])
    @comment = @hunt.comments.build(user: current_user)
    render :show
  end

  def new
    @hunt = Hunt.new
    @location = Location.new
    @hunt.location = @location
    add_items(10, @hunt)
    @locations = Location.all
  end

  def create
    @hunt = Hunt.new(hunt_params)
    @hunt.owner = current_user
    if @hunt.valid?
      @hunt.save
      redirect_to hunt_path(@hunt)
    else
      render :new
    end
  end

  def edit
    @hunt = Hunt.find(params[:id])
    require_ownership(@hunt)
    add_items(5, @hunt)
  end

  def update
    @hunt = Hunt.find(params[:id])
    require_ownership(@hunt)
    if @hunt.update(hunt_params)
      redirect_to hunt_path(@hunt)
    else
      render :edit
    end
  end

  private

  def require_ownership(hunt)
    return redirect_to root_path unless hunt.owner == current_user
  end

  def add_items(num, hunt)
    num.times do
      hunt.items.build
    end
  end

  def hunt_params
    params.require(:hunt).permit(
      :name,
      :start_time,
      :finish_time,
      :meeting_place,
      location_attributes: [
        :id,
        :city,
        :state
      ],
      items_attributes: [
        :id,
        :name,
        :_destroy
      ],
      comments_attributes: [
        :text,
        :user_id
      ]
    )
  end
end
