require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'

require 'catalogerSchema.rb'

dbconfig = YAML::load(File.open("database.yaml"))
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(File.open("activerecord.log", "w+"))
ActiveRecord::Base.colorize_logging = false

class CourseLecture < ActiveRecord::Base
	belongs_to :course
	has_and_belongs_to_many :schedules
	
	# courseLectureCode:string
	# enrollmentMax:int
	# enrollmentCurrent:int
	# days:string
	# startTime:int
	# endTime:int
	# locationCode:string
	# instructorName:string
	# lectureType:string
	
	# updateURL:string (example: "http://info.sjsu.edu/web-dbgen/soc-fall-courses/c667552.html")
	
	validates_presence_of :course
	validates_presence_of :schedules
	
end

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
	validates_format_of :course_code, :with => /^\w+\d+\w*$/
	validates_uniqueness_of :course_code
end

class Department < ActiveRecord::Base
	has_many :courses
	
	# departmentCode:string (example: "ANTH")
	# name:string
	
	validates_uniqueness_of :name, :on => :save
end

class Schedule < ActiveRecord::Base
	has_and_belongs_to_many :course_lectures
	
	# name:string
end


