class Course < ActiveRecord::Base
  acts_as_ferret :fields => {
    :name => {:index => :untokenized}, 
    :code => {:index => :untokenized}
  }
  
	has_many :course_sections
	belongs_to :department
	
	validates_presence_of :department
	
	validates_format_of :code, :with => /^\w+\d+\w*$/
	validates_uniqueness_of :code
end
