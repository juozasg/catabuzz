require 'csv'

module CourseSectionsHelper
  def createNotesTable
    @notesTable = []
    CSV.open("public/classnotes.csv", "r").each { |row| @notesTable << row[1]}
  end
  
  def getNoteText(noteNumber)
    createNotesTable if(@notesTable.nil?)
    return @notesTable[noteNumer - 1]
  end
end
