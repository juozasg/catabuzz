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
