class Department < ActiveRecord::Base
  acts_as_ferret :fields => [:name, :code]
    
	has_many :courses
	
	validates_uniqueness_of :name, :on => :save
	
end
