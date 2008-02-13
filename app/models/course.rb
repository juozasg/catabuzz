class Course < ActiveRecord::Base
  acts_as_ferret :field => [:name, :course_code]
  
	has_many :course_lectures
	belongs_to :department
	
	# course_code:string (example: "LING101")
	# name:string (full name if available, short name otherwise)
	# description:text
	# prerequisites:string
	# corequisites:string
	# misc:string
	# units:int
	
	validates_presence_of :department
	
	# no spaces in course_code (no "LING 101")
	validates_format_of :course_code, :with => /^\w+\d+\w*$/
	validates_uniqueness_of :course_code
end
