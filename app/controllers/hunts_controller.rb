class HuntsController < ApplicationController
  helper_method :params

  def index
    if current_user
      @hunts = Hunt.all_pending
      render :index
    else
      redirect_to root_path
    end
  end

  def show
  end
end
