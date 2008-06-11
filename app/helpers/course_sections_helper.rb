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
    logger.error "--------"
    @@courseTypeNamesTable.inspect
    @@courseTypeNamesTable = {
      "LEC" => "Lecture",
  		"ACT" => "Activity",
  		"LAB" => "Laboratory", 
  		"SEM" => "Seminar", 
  		"SUP" => "Supervision"
    }
    @@courseTypeNamesTable.default = ""
    puts @@courseTypeNamesTable.inspect
    puts "---------------"
  end
    
  def get_note_text(noteNumber)
    puts "++++++++++++++\n"
    puts @@courseTypeNamesTable.inspect
    create_notes_table if(@@footnotesTable.nil?)
    logger.error @@courseTypeNamesTable.inspect
    logger.error "\n++++++++++++++\n"    
    return @@footnotesTable[noteNumer - 1]
  end
  
  def get_course_type_name(courseTypeCode)
    create_course_type_names_table if(@@courseTypeNamesTable)
    return @@courseTypeNamesTable[courseTypeCode]
  end
  
  def dropdown_title
    "#{@section.course.code} - #{@section.course.name}" 
  end
  
  def type_and_units_text
    open("dump.txt", "a+") {|f| f.write "\n"; f.write(@section.inspect); f.write "\n"; f.close}
    return "ok"
    type = get_course_type_name(@section.type)
    units = @section.course.units or ""
    "#{type} (#{units} units)"
  end
end
