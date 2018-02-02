# controller for root route
class WelcomeController < ApplicationController
  def index
    if current_user && !!current_user.location
      @nearby_hunts = Hunt.pending_in(current_user.location)
    else
      @nearby_hunts = nil
    end
    @top_five = Hunt.top_five
  end
end
