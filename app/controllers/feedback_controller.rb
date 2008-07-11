class FeedbackController < ApplicationController
  
  # GET /feedback
  def index
    layout = "feedback_external"
    layout = false if params.include? :ajax
    render :layout => layout
  end
  
  # POST /feedback
  def create
    # send notification (limit message size)
    Notifier.deliver_feedback_comments(params[:email][0..512], params[:comments][0..10000])
    render :layout => "feedback_external"
  end
  
end
