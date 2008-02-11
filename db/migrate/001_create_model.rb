class CreateModel < ActiveRecord::Migration
  
  def self.up	
  	# JOIN TABLE for Course and CourseLecture
  	create_table :course_lectures_schedules, :id => false do |t|
		t.integer :course_lecture_id, :null => false
		t.integer :schedule_id, :null => false
	end
	
	# CourseLecture
	create_table :course_lectures do |t|
		t.string :course_lecture_code
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
		t.string :course_code
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
	drop_table :course_lectures	
	drop_table :course_lectures_schedules
  end
end
