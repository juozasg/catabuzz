class CourseSectionsController < ApplicationController
  # GET /course_sections/1
  def show
    @course_section = CourseSection.find(params[:id])
    render :layout => false
  end
end
