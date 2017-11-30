class HuntsController < ApplicationController
  def index
    if current_user
      render :index
    else
      redirect_to root_path
    end 
  end

  def show
  end
end
