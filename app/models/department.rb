class Department < ActiveRecord::Base
	has_many :courses
	
	# departmentCode:string (example: "ANTH")
	# name:string
	
	validates_uniqueness_of :name, :on => :save
end