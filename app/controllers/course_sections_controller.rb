class CourseSectionsController < ApplicationController
  
  # GET /course_sections/1
  def show
    @section = CourseSection.find(params[:id])
    layout = "course_section_show_external"
    layout = false if params.include? :ajax
    render :layout => layout
  end
end
