# controller for creation of comments
class CommentsController < ApplicationController
  before_action :require_login

  def new; end

  def create
    @hunt = Hunt.find(params[:hunt_id])
    @hunt.comments.build(comment_params)
    if @hunt.save
      redirect_to hunt_path(@hunt)
    else
      @comment = @hunt.comments.build(user: current_user)
      render :"hunts/show"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text, :user_id)
  end
end
