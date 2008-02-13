class Department < ActiveRecord::Base
  acts_as_ferret :field => [:name]
    
	has_many :courses
	
	# departmentCode:string (example: "ANTH")
	# name:string
	
	validates_uniqueness_of :name, :on => :save
end
