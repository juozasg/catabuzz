require 'csv'
require 'logger'

module CourseSectionsHelper
  @@footnotesTable = nil
  @@courseTypeNamesTable = nil
  
  def create_notes_table
    @@footnotesTable = []
    CSV.open("public/classnotes.csv", "r").each { |row| @@footnotesTable << row[1]}
  end
  
  def create_course_type_names_table
    @@courseTypeNamesTable = {
      "LEC" => "Lecture",
  		"ACT" => "Activity",
  		"LAB" => "Laboratory", 
  		"SEM" => "Seminar", 
  		"SUP" => "Supervision"
    }
    @@courseTypeNamesTable.default = ""
  end
    
  def get_note_text(noteNumber)
    create_notes_table if(@@footnotesTable.nil?)
    return @@footnotesTable[noteNumer - 1]
  end
  
  def get_course_type_name(courseTypeCode)
    create_course_type_names_table if(@@courseTypeNamesTable.nil?)
    return @@courseTypeNamesTable[courseTypeCode]
  end
  
  def dropdown_title
    "#{@section.course.code} - #{@section.course.name}" 
  end
  
  def type_and_units_text
    open("dump.txt", "a+") {|f| f.write "\n"; f.write(@section.inspect); f.write "\n"; f.close}
    type = get_course_type_name(@section.type_code)
    units = @section.course.units or ""
    "#{type} (#{units} units)"
  end
  
  def has_prerequisites
    @section.course.prerequisites and @section.course.prerequisites != ""
  end
  
  def prerequisites_text
    return "" unless has_prerequisites
    "Prerequisites: " + @section.course.prerequisites
  end
  
  def has_corequisites
    @section.course.corequisites and @section.course.corequisites != ""
  end
  
  def corequisites_text
    return "" unless has_corequisites
    "Corequisites: " + @section.course.corequisites
  end
  
  def has_misc
    @section.course.misc and  @section.course.misc != ""
  end
  
  def misc_text
    return "" unless has_misc
    @section.course.misc
  end
end
