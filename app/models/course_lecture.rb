class CourseSection < ActiveRecord::Base
  acts_as_ferret :fields => [:days, :start_time, :end_time, :instructor, :code, :course_name]
	belongs_to :course
	has_and_belongs_to_many :schedules	
	
	def course_code
		return self.course.course_code
	end
	
	def course_name
		return self.course.name
	end
	
	def units
		return self.course.units
	end
	
	validates_presence_of :course
	validates_presence_of :schedules
end
