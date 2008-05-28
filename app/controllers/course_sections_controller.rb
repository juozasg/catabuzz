class CourseSectionsController < ApplicationController
  # GET /course_sections/1
  # GET /course_sections/1.xml
  def show
    render :text => "got it #{params[:id]}"
  
#    @course_section = CourseSection.find(params[:id])

#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @course_section }
#    end
  end



  # DELETE /course_sections/1
  # DELETE /course_sections/1.xml
  def destroy
    # @course_section = CourseSection.find(params[:id])
    #    @course_section.destroy
    # 
    #    respond_to do |format|
    #      format.html { redirect_to(course_sections_url) }
    #      format.xml  { head :ok }
    #    end
  end

end
