class WelcomeController < ApplicationController
  def index
    current_user && !!current_user.location ? @nearby_hunts = Hunt.pending_in(current_user.location) : @nearby_hunts = nil
    @top_five = Hunt.top_five
  end
end
