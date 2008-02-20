class CourseFinderController < ApplicationController
  def index
  	@results = nil
  	
  	puts params.inspect
    query = params["q"]
    
    
    unless query.nil? or query.empty?
      @results = get_results(query)
  	end
    render 
  end
  
  def get_results(query)
    lectures = CourseLecture.find_by_contents
  	
  	
  	
    
  end
  
 
end
