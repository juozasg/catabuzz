class CourseLecturesController < ApplicationController
  # GET /course_lectures
  # GET /course_lectures.xml
  def index
    @course_lectures = CourseLecture.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_lectures }
    end
  end

  # GET /course_lectures/1
  # GET /course_lectures/1.xml
  def show
    @course_lecture = CourseLecture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course_lecture }
    end
  end

  # GET /course_lectures/new
  # GET /course_lectures/new.xml
  def new
    @course_lecture = CourseLecture.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course_lecture }
    end
  end

  # GET /course_lectures/1/edit
  def edit
    @course_lecture = CourseLecture.find(params[:id])
  end

  # POST /course_lectures
  # POST /course_lectures.xml
  def create
    # @course_lecture = CourseLecture.new(params[:course_lecture])
    # 
    # respond_to do |format|
    #   if @course_lecture.save
    #     flash[:notice] = 'CourseLecture was successfully created.'
    #     format.html { redirect_to(@course_lecture) }
    #     format.xml  { render :xml => @course_lecture, :status => :created, :location => @course_lecture }
    #   else
    #     format.html { render :action => "new" }
    #     format.xml  { render :xml => @course_lecture.errors, :status => :unprocessable_entity }
    #   end
    # end
  end

  # PUT /course_lectures/1
  # PUT /course_lectures/1.xml
  def update
    # @course_lecture = CourseLecture.find(params[:id])
    # 
    #    respond_to do |format|
    #      if @course_lecture.update_attributes(params[:course_lecture])
    #        flash[:notice] = 'CourseLecture was successfully updated.'
    #        format.html { redirect_to(@course_lecture) }
    #        format.xml  { head :ok }
    #      else
    #        format.html { render :action => "edit" }
    #        format.xml  { render :xml => @course_lecture.errors, :status => :unprocessable_entity }
    #      end
    #    end
  end

  # DELETE /course_lectures/1
  # DELETE /course_lectures/1.xml
  def destroy
    # @course_lecture = CourseLecture.find(params[:id])
    #    @course_lecture.destroy
    # 
    #    respond_to do |format|
    #      format.html { redirect_to(course_lectures_url) }
    #      format.xml  { head :ok }
    #    end
    #  end
end
