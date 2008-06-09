class Course < ActiveRecord::Base
  acts_as_ferret :fields => {
    :name => {:index => :untokenized}, 
    :code => {:index => :untokenized}
  }
  
	has_many :course_sections
	belongs_to :department
	
	validates_presence_of :department
	
	# can have spaces in course_code (ie "BUS3 101A")
	validates_format_of :code, :with => /^\w+\d+\w*$/
	validates_uniqueness_of :code
end
