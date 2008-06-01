class CourseSectionsController < ApplicationController
  # GET /course_sections/1
  # GET /course_sections/1.xml
  def show
    @course_section = CourseSection.find(params[:id])
    render :layout => false
    #render :text => "got it #{params[:id]}"
  
#    @course_section = CourseSection.find(params[:id])

#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @course_section }
#    end
  end


end
