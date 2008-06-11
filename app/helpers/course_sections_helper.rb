require 'csv'

module CourseSectionsHelper
  def createNotesTable
    @notesTable = []
    CSV.open("public/classnotes.csv", "r").each { |row| @notesTable << row[1]}
  end
  
  def createCourseTypeNamesTable
    @typeNamesTable = {
      "LEC" => "Lecture",
  		"ACT" => "Activity",
  		"LAB" => "Laboratory", 
  		"SEM" => "Seminar", 
  		"SUP" => "Supervision"
    }
    @typeNamesTable.default = ""
  end
    
  def getNoteText(noteNumber)
    createNotesTable if(@notesTable.nil?)
    return @notesTable[noteNumer - 1]
  end
  
  def courseTypeName(courseTypeCode)
    createCourseTypeNamesTable if(@typeNamesTable)
    return @typeNamesTable[courseTypeCode]
  end
  
  def get_dropdown_title(section)
    "ANTH101 - Introduction to Anthopology"
  end
end
