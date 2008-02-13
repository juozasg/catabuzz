class Schedule < ActiveRecord::Base
  acts_as_ferret :field => [:name]
	has_and_belongs_to_many :course_lectures
	
	# name:string
end
