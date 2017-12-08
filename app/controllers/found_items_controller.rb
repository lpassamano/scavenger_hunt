class FoundItemsController < ApplicationController
  def update
    found_item = FoundItem.find(found_item_params)
    found_item.found = true
    found_item.save
    redirect_to hunt_team_path(params[:hunt_id], params[:team_id])
  end

  private

  def found_item_params
    params.require(:found_item_id)
  end
end
