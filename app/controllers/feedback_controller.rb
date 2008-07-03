class FeedbackController < ApplicationController
  
  # GET /feedback
  def index
   render :layout => "feedback_external"
  end
  
  # POST /feedback
  def create
    render :layout => "feedback_external"
  end
  
end
