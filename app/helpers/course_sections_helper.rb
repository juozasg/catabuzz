require 'csv'
require 'logger'

module CourseSectionsHelper
  @@footnotesTable = nil
  @@courseTypeNamesTable = nil
  
  def create_notes_table
    # use a hash because certain footnote numbers are not available
    @@footnotesTable = Hash.new("")
    CSV.open("public/classnotes.csv", "r").each { |row| @@footnotesTable[row[0]] = row[1]}
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
    
  def get_note_text(noteId)
    create_notes_table if(@@footnotesTable.nil?)
    return @@footnotesTable[noteId]
  end
  
  def get_course_type_name(courseTypeCode)
    create_course_type_names_table if(@@courseTypeNamesTable.nil?)
    return @@courseTypeNamesTable[courseTypeCode]
  end
  
  def dropdown_title
    "#{@section.course.code} - #{@section.course.name}" 
  end
  
  def type_and_units_text
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
  
  def section_code_text
    "Section Code: " + @section.code.to_s
  end
  
  def grading_text
    "Grading Rules: " + @section.course.grading.to_s
  end
  
  def has_repeatable
    @section.course.repeatable and @section.course.repeatable != ""
  end
  
  def repeatable_text
    return "" unless has_repeatable
    "Repeatable: " + @section.course.repeatable.to_s
  end
  
  def has_general_education
    @section.course.general_education and @section.course.general_education != ""
  end
  
  def general_education_text
    return "" unless has_general_education
    "General Education: " + @section.course.general_education
  end
  
  def has_california_articulation_number
    @section.course.california_articulation_number and @section.course.california_articulation_number != ""
  end
  
  def california_articulation_number_text
    return "" unless has_california_articulation_number
    "California Articulation Number: " +  @section.course.california_articulation_number
  end
  
  def has_footnotes
    @section.footnotes and @section.footnotes != ""
  end
  
  def footnotes_text
    return "" unless has_footnotes
    notes = @section.footnotes.split(",").map { |note| "[#{note}] " + get_note_text(note)}
    return notes.join(" ")
  end
  
end
