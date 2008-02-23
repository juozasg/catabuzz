class Department < ActiveRecord::Base
  acts_as_ferret :fields => [:name, :code]
    
	has_many :courses
	
	# departmentCode:string (example: "ANTH")
	# name:string
	
	validates_uniqueness_of :name, :on => :save
	validates_uniqueness_of :code, :on => :save
	
end
