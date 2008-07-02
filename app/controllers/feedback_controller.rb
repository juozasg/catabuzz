class FeedbackController < ApplicationController
  def index
    # render :text => "please enter your feedback"
  end
  
  def create
    render :text => "form submitted"
  end
  
end
