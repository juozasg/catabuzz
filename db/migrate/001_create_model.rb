class CreateModel < ActiveRecord::Migration
  
  def self.up	
  	# JOIN TABLE for Course and CourseLecture
  	create_table :course_sections_schedules, :id => false do |t|
		t.integer :course_section_id, :null => false
		t.integer :schedule_id, :null => false
	end
	
	# CourseLecture
	create_table :course_sections do |t|
		t.string :course_section_code
		t.integer :enrollment_max
		t.integer :enrollment_current
		t.string :days
		t.integer :start_time
		t.integer :end_time
		t.string :location
		t.string :instructor
		t.string :update_url
		t.string :footnotes
		t.string :type
		t.string :section
		
		t.integer :course_id, :null => false
	end
	
	# Course
	create_table :courses do |t|
		t.string :code
		t.string :name #(full name if available, short name otherwise)
		t.text :description
		t.string :prerequisites
		t.string :corequisites
		t.string :misc
		t.integer :units
		
		t.integer :department_id, :null => false
	end
	
	# Department
	create_table :departments do |t|
		t.string :name
		t.string :code
	end
	
	# Schedule
	create_table :schedules do |t|
		t.string :name
	end
	
   
  end

  def self.down
    drop_table :schedules
    drop_table :departments
    drop_table :courses
    drop_table :course_sections	
    drop_table :course_sections_schedules
  end
end
