module CourseFinderHelper
  
  def format_lecture_time(time)
    hours, mins = time.divmod(100)
    sprintf("%.2d:%.2d", hours, mins)
  end
  
end
