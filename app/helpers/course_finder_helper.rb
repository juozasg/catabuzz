module CourseFinderHelper
  
  def format_lecture_time(time)
    return "TBA" unless time.respond_to? :divmod
    hours, mins = time.divmod(100)
    sprintf("%.2d:%.2d", hours, mins)
  end
  
  def format_enrollment(current, max)
    return "#{current} / #{max}"
  end
  
  def get_enrollment_cell_class(current, max)
      return "enrollment_unavailable" if max.to_i < 1
      case current / max.to_f 
      when 0.0...0.8
        "enrollment_available"
      when 0.8...1.0
        "enrollment_near_full"
      when 1.0...10.0
        "enrollment_full"
      else
        raise "Strange enrollment numbers here!: #{current / max.to_f}"
      end
  end
  
end
