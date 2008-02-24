class Course < ActiveRecord::Base
  acts_as_ferret :fields => [:name, :code]
  
	has_many :course_sections
	belongs_to :department
	
	validates_presence_of :department
	
	# no spaces in course_code (no "LING1 101A")
	validates_format_of :code, :with => /^\w+\d+\w*$/
	validates_uniqueness_of :code
end
