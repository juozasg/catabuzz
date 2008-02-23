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
    ferret_query = build_ferret_query(query)
    
    puts "ferret_query = " + "'" + ferret_query + "'"
    lectures = CourseLecture.find_by_contents(ferret_query, {:limit => 20})
    
    return lectures
    
  end
  
private

  def build_ferret_query(query)
    result = ""
  
    tokens = {}
    # split the query string into tokens
  
    for token in query.split(/,|\s/) do
      next if token.nil? or token.empty?
    
      case token
      when /M?T?W?R?F?S?(SU)?(TBA)?/
        tokens[:days] = token
      end
    
    
    end
  
    # collect ferret arguments
    unless tokens[:days].nil?
      result << " days:#{tokens[:days]}"
    end
  
    return result
  end  
 
end
