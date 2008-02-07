class Course < ActiveRecord::Base
	has_many :course_lectures
	belongs_to :department
	
	# courseCode:string (example: "LING101")
	# name:string (full name if available, short name otherwise)
	# description:text
	# prerequisites:string
	# corequisites:string
	# misc:string
	# units:int
	
	validates_presence_of :department
	
	# no spaces in courseCode (no "LING 101")
	validates_format_of :courseCode, :with => /^\w+\d+\w*$/
	validates_uniqueness_of :courseCode
end
