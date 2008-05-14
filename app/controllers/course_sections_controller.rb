class CourseSectionsController < ApplicationController
  # GET /course_sections
  # GET /course_sections.xml
  def index
    @course_sections = CourseSection.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_sections }
    end
  end

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

  # GET /course_sections/new
  # GET /course_sections/new.xml
  def new
    @course_section = CourseSection.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course_section }
    end
  end

  # GET /course_sections/1/edit
  def edit
    @course_section = CourseSection.find(params[:id])
  end

  # POST /course_sections
  # POST /course_sections.xml
  def create
    # @course_section = CourseSection.new(params[:course_section])
    # 
    # respond_to do |format|
    #   if @course_section.save
    #     flash[:notice] = 'CourseSection was successfully created.'
    #     format.html { redirect_to(@course_section) }
    #     format.xml  { render :xml => @course_section, :status => :created, :location => @course_section }
    #   else
    #     format.html { render :action => "new" }
    #     format.xml  { render :xml => @course_section.errors, :status => :unprocessable_entity }
    #   end
    # end
  end

  # PUT /course_sections/1
  # PUT /course_sections/1.xml
  def update
    # @course_section = CourseSection.find(params[:id])
    # 
    #    respond_to do |format|
    #      if @course_section.update_attributes(params[:course_section])
    #        flash[:notice] = 'CourseSection was successfully updated.'
    #        format.html { redirect_to(@course_section) }
    #        format.xml  { head :ok }
    #      else
    #        format.html { render :action => "edit" }
    #        format.xml  { render :xml => @course_section.errors, :status => :unprocessable_entity }
    #      end
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
