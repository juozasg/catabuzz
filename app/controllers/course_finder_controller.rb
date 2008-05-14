require "search_query_parser.rb"

class CourseFinderController < ApplicationController
  def index
  	@results = nil
  	
  	puts params.inspect
    query = params["q"]
    
    
    unless query.nil? or query.empty?
      @results = get_results(query, params[:page])
  	end
    render 
  end
  
  def get_results(query, page)
    ferret_query = SearchQueryParser::build_ferret_query(query)
    
    puts "ferret_query = " + "'" + ferret_query + "'"

    sections = CourseSection.ferret_paginate_search(ferret_query, :page => page, :per_page => 20)
    #lectures = CourseSection.find_by_contents(ferret_query, {:limit => 20})
    
    return sections
  end
end
