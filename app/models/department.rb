class Department < ActiveRecord::Base
  acts_as_ferret :fields => {
    :name => {:index => :untokenized}, 
    :code => {:index => :untokenized}
  }
  
    
	has_many :courses
	
	validates_uniqueness_of :name, :on => :save
	
end
