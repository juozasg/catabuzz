class FeedbackController < ApplicationController
  def index
    render :layout => "feedback_external"
  end
  
  def create
    render :text => "form submitted"
  end
  
end
