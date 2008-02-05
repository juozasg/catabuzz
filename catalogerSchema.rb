require 'rubygems'
require 'active_record'

class CatalogerSchema
	def CatalogerSchema.createTables
		# HABTM
		ActiveRecord::Schema.define do
			create_table :course_lectures_schedules, :id => false do |t|
				t.integer :course_lecture_id, :null => false
				t.integer :schedule_id, :null => false
			end
		end
		
		# CourseLectures
		ActiveRecord::Schema.define do
			create_table :course_lectures do |t|
				t.string :courseLectureCode
				t.integer :enrollmentMax
				t.integer :enrollmentCurrent
				t.string :days
				t.integer :startTime
				t.integer :endTime
				t.string :location
				t.string :instructor
				t.string :updateURL
				t.string :footnotes
				t.string :type
				t.string :section
				
				t.integer :course_id, :null => false
			end
		end
		
		# Courses
		ActiveRecord::Schema.define do
			create_table :courses do |t|
				t.string :courseCode
				t.string :name #(full name if available, short name otherwise)
				t.text :description
				t.string :prerequisites
				t.string :corequisites
				t.string :misc
				t.integer :units
				
				t.integer :department_id, :null => false
			end
		end
		
		# Departments
		ActiveRecord::Schema.define do
			create_table :departments do |t|
				t.string :name
			end
		end
		
		# Schedule
		ActiveRecord::Schema.define do 
			create_table :schedules do |t|
				t.string :name
			end
		end
		
	end
	
	def CatalogerSchema.dropTables
		ActiveRecord::Schema.define do
			drop_table :schedules
			drop_table :departments
			drop_table :courses
			drop_table :course_lectures	
			drop_table :course_lectures_schedules
		end
	end
	
end