class CourseSection < ActiveRecord::Base
  acts_as_ferret :fields => {
    :days => {:index => :untokenized}, 
    :start_time => {:index => :untokenized},
    :end_time => {:index => :untokenized},
    :instructor => {},
    :course_code => {:index => :untokenized},
    :course_name => {},
    :department_name => {:index => :untokenized, :store => :yes},
    :department_code => {:index => :untokenized}
  }

	belongs_to :course
	has_and_belongs_to_many :schedules	
	
	def course_code
		return self.course.code
	end
	
	def course_name
		return self.course.name
	end
	
	def units
		return self.course.units
	end

  def department_code
    return self.course.department.code
  end

  def department_name
    return self.course.department.name
  end
  
	validates_presence_of :course
	validates_presence_of :schedules
end
