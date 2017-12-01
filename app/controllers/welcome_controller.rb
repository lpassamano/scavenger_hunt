class WelcomeController < ApplicationController
  def index
    @top_five = Hunt.top_five
  end
end
