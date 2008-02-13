class CourseFinderController < ApplicationController
  def index
    query = params["q"]
    unless query.nil? or query.empty?
      @results = get_results(query)
    render 
  end
  
  def get_results(query)
    
  end
  
 
end
