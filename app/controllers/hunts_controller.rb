class HuntsController < ApplicationController
  # do a before each check!
  def index
    if current_user
      @locations = Location.all
      if !params[:location].blank?
        @hunts = Hunt.pending_in(params[:location])
      else
        @hunts = Hunt.pending
      end
      render :index
    else
      redirect_to root_path
    end
  end

  def show
    if current_user
      @hunt = Hunt.find(params[:id])
      render :show
    else
      redirect_to root_path
    end
  end
end
