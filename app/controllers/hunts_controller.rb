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
    add_items(5, @hunt)
    require_ownership(@hunt)
  end

  def update
    @hunt = Hunt.find(params[:id])
    if @hunt.update(hunt_params)
      redirect_to hunts_path(@hunt)
    else
      render :edit
    end
  end

  private

  def require_login
    return redirect_to root_path unless current_user
  end

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
      location_attributes: [
        :id,
        :city,
        :state
      ],
      items_attributes: [
        :id,
        :name,
        :_destroy
      ]
    )
  end
end
