class HuntsController < ApplicationController
  def index
    if current_user
      @locations = Location.all
      if !params[:location].blank?
        @hunts = Location.pending_hunts(params[:location])
      else
        @hunts = Hunt.all_pending
      end
      render :index
    else
      redirect_to root_path
    end
  end

  def show
  end
end
