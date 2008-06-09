# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "course_sections", :force => true do |t|
    t.string  "course_section_code"
    t.integer "enrollment_max"
    t.integer "enrollment_current"
    t.string  "days"
    t.integer "start_time"
    t.integer "end_time"
    t.string  "location"
    t.string  "instructor"
    t.string  "ge_designator"
    t.string  "footnotes"
    t.string  "type"
    t.string  "section"
    t.string  "code"
    t.integer "course_id",           :null => false
  end

  create_table "course_sections_schedules", :id => false, :force => true do |t|
    t.integer "course_section_id", :null => false
    t.integer "schedule_id",       :null => false
  end

  create_table "courses", :force => true do |t|
    t.string  "code"
    t.string  "name"
    t.text    "description"
    t.string  "prerequisites"
    t.string  "corequisites"
    t.string  "misc"
    t.string  "units"
    t.string  "general_education"
    t.string  "grading"
    t.string  "repeatable"
		t.string  "california_articulation_number"
    t.integer "department_id", :null => false
  end

  create_table "departments", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "schedules", :force => true do |t|
    t.string "name"
  end

end
