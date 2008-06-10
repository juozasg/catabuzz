require "ostruct"
require 'rubygems'
require 'hpricot'

class CatalogScraper
  
  def initialize(localHostRoot, location)
    #localHostRoot: "./downloads"
    #location: "/web-dbgen/soc-fall-courses/"
    
    @localHostRoot = localHostRoot
    @location = location
    
    @courseInfoFields = {}
  end
  
  def scrape
		depListUrl = File.join(@localHostRoot, @location, "/all-departments.html")
		
		puts "Scraping data from #{File.join(@localHostRoot, @location)}"
		
		# create Schedule
		schedule = createSchedule(depListUrl)
		
		# get the list of department
		depList = scrapeDepartmentList(depListUrl)

		# handle each department
		depList.each_with_index { |depItem, i|  			
			puts "(#{i + 1} of #{depList.length}) -- #{depItem.name}"

			createDepartmentAndCourses(depItem.name, depItem.href, schedule)
		}
		
		puts "Course info fields:"
		@courseInfoFields.each_key { |key| puts "'#{key}'"}
		puts ""
		
		puts "Scraper...Done!"
			
	end
	
	def cutContentPortionFromDoc(doc)
		text = doc.inner_html
		md = /<!-- content starts here -->(.*?)<!-- content ends here -->/m.match(text)
		
		return Hpricot(md[1])
	end
	
  
	def createSchedule(rootUrl)
	  rootDoc = cutContentPortionFromDoc(Hpricot(open(rootUrl)))
		
		scheduleName = rootDoc.at(:h3).inner_text
		
		schedule = Schedule.create(:name => scheduleName)
		schedule.save!
		
		return schedule
	end
	
	def createDepartmentAndCourses(depName, depUrl, schedule)
	  	#departments can be listed twice, so first check for existing ones
			department = Department.find(:first, :conditions => ["name = ?", depName])
			if(department.nil?)
		    department = Department.create(:name => depName)
	    end

			# get the list of sections for this department
			sectionListUrl = File.join(@localHostRoot, depUrl)
			courseSectionList = scrapeCourseSectionList(sectionListUrl)
			
			# set the department code if we don't have one
			# use the first course section in the list to get the department code
			if department.code.nil?
		  	unless courseSectionList[0].nil?
  			  department.code = courseSectionList[0].departmentCode
  		  else
  		    department.code = "undefined"
  		  end
  		  department.save!
      end
						
			# we have a list of course sections now, which belong to Courses
			# we should create a Course (or use an existing one)
			# then create a course section
			courseSectionList.each do |sectionItem|
			  shortName = sectionItem.shortName
			  courseCode = sectionItem.courseCode
			  
			  # create or find a course for this course section
			  course = createOrFindCourse(courseCode, shortName, department)
			  
			  # create the course section
			  courseSection = createCourseSection(sectionItem.courseSectionUrl)
			  courseSection.course = course
			  courseSection.schedules << schedule
			  courseSection.save
			
			end
			
  end
  
  def createOrFindCourse(code, shortName, department)
    course = Course.find(:first, :conditions => ["code =?", code])
		if course.nil?
		  courseCatalogUrl = File.join(@localHostRoot, "/web-dbgen/catalog/courses/", code + ".html")
			courseData = scrapeCourseDescription(courseCatalogUrl)
			courseData.name = (courseData.full_name or shortName)
			courseData.code = code
			
			courseData.delete_field("full_name")
			course = Course.create(courseData.marshal_dump)
		end
		
		course.department = department
		course.save!
		
		return course
  end
  
  def createCourseSection(sectionUrl)
    # sectionUrl => "/web-dbgen/soc-fall-courses/c667543.html"
    fullSectionUrl = File.join(@localHostRoot, sectionUrl)
    
    courseSectionInfo = scrapeCourseSection(fullSectionUrl)
    courseSection = CourseSection.new(courseSectionInfo.marshal_dump)

    return courseSection
  end
  
  def scrapeDepartmentList(url)
	  # results << OpenStruct.new(:href => '/web-dbgen/soc-spring-courses/d22710.html', name => 'ADVERTISING')
	  doc = cutContentPortionFromDoc(Hpricot(open(url)))
	  		
	  # scrape department list
		results = []
		
		(doc/"table tr").each { |row|
			a = row.at("td a")
			results << OpenStruct.new(:href => a["href"], :name => a.inner_text)
		}
	  
	  return results
  end
	
	def scrapeCourseSectionList(url)
		# results << OpenStruct.new(:courseCode => "ADV091", :departmentCode => "ADV", :shortName => "Intro Advertising", :courseSectionUrl => "/web-dbgen/soc-fall-courses/c667543.html")
		results = []
		
		doc = cutContentPortionFromDoc(Hpricot(open(url)))
		
		lectureListTable = (doc/"table")[2]
		
		unless lectureListTable.nil?
			lectureListTable.search("tr") do |row|
				cols = row.search("td")
				a = cols[0].at("a")
				
				courseSectionUrl = a["href"]		
				departmentCode, numericPart = a.inner_text.split(" ")
				courseCode = departmentCode + numericPart
				courseShortName = cols[2].inner_text
				
				os = OpenStruct.new(:courseCode => courseCode, :departmentCode => departmentCode, :shortName => courseShortName, :courseSectionUrl => courseSectionUrl)				
				results << os
			end
	
		end

		return results
	end
	
	def scrapeCourseDescription(url)
		# result = OpenStruct.new(:full_name => "Introduction To Linguistics", :description => "SCIENTIFIC study of lang...", 
		# 							:prerequisites => "...", :corequisites => "...", :misc => "...", :units => 3,
		#               :general_education => "...", :grading => "...", :california_articulation_number => "...")
  
		result = OpenStruct.new
		
		# some descriptions don't exist
		# don't bother if we can't open it
		return result unless File.exists?(url) and File.size(url) > 0
		
		
		doc = cutContentPortionFromDoc(Hpricot(open(url)))
		# Hpricot closes nested paragraphs at the end
		# we can have a much easier time if we fix each nested paragraph ourselves
		doc = Hpricot(fixNestedParagraphs(doc.to_html))

		result.full_name = doc.at(:h4).inner_text
		
		# find description text and units text nodes
		titles = (doc/"p b").collect {|b| b.inner_text}
		ps = doc/"p"
		ival = 0
		values = []
    ps.each do |p|
      if p.at("b").nil?
        # this is not a paragraph that has the title
        # so the data in the p should belong to previous data
        (p/"br").remove
        values[ival - 1] << "\n"
        values[ival - 1] << p.inner_text.strip
      else
        (p/"b").remove
        (p/"br").remove
        values << p.inner_text.strip
        ival += 1
      end
    end
		
	  values.each_with_index do |val, i|
	    key = titles[i].downcase.gsub(" ", "_")
	    #parentheses in methods names are bad
	    key = "california_articulation_number" if key == "california_articulation_number_(can)"
	    result.send("#{key}=", val)
	    @courseInfoFields[key] = true
    end
    
		# split up description text			
		parts = result.description.to_s.split("\n\n").reject { |v| v.nil? or v.empty? }
  	result.description = parts.shift
  	result.misc = ""
  	result.prerequisites = ""
  	result.corequisites = ""
  	until parts.empty?
  	  part = parts.shift
  	  case part
	    when /Prerequisite:/
	      result.prerequisites = part.gsub(/Prerequisite:\s*/, "")
      when /Corequisite:/
	      result.corequisites = part.gsub(/Corequisite:\s*/, "")
  	  else
  	    result.misc << part
  	    result.misc << "\n"
	    end
	  end
  	
		return result
	end
	
	def scrapeCourseSection(url)
		# results << OpenStruct.new(:course_section_code => "40033", :footnotes => "73", :section => "01", :type => "LEC", :current_enrollment => 67,
		# 	 							:max_enrollment => 70, :days => "MW", :start_time => 900, :end_time => 1015, :location => "DBH 222",
		# 								:instructor => "N Digre")
		result = OpenStruct.new
		doc = cutContentPortionFromDoc(Hpricot(open(url)))
		
		table = doc.at("p:nth(1) > table")
		
		# we have some bad HTML here, so the safest thing to do is to turn the table into a hash
		data = {}
		table.search("tr").each do |row|
			key = row.at("td:nth(0)").inner_text unless row.at("td:nth(0)").nil?
			val = row.at("td:nth(2)").inner_text unless row.at("td:nth(2)").nil?

			key = key.downcase.gsub(" ", "_") unless key.nil?
			data[key.to_sym] = val unless (key.empty? or val.split.join.empty?)
		end
		
		# some data is ready, just dump it into result
		result.marshal_load(data)
		
		# convert some stuff
		md = /(\d+)\/(\d+)/.match(result.enrollment)
		result.enrollment_current = md[1].to_i
		result.enrollment_max = md[2].to_i
		
		# split time
		md = /(\d+)\s+(\d+)/.match(result.time)
		# check for unannounced times
		unless /TBA/ =~ result.time
			result.start_time = md[1].to_i
			result.end_time = md[2].to_i
		else
			result.start_time = result.end_time = nil
		end
		
		# delete extra stuff from result
		[:time, :enrollment, :dates, :title, :units, :schedule].map {|s| result.delete_field(s)}
		
		return result
	end
	
	def fixNestedParagraphs(text)
	  return text if text.index("<p>").nil?
	  
	  processed = ""
	  inp = false
	  until text.empty?
	    if inp
	      firstp = text.index(/<\s*p/)
	      firstep = text.index(/<\s*\/\s*p/)
	      # unclosed p tag. no p tags left
	      if(firstp.nil? and firstep.nil?)
	        processed << text
	        processed << "</p>\n"
	        text = ""
	        inp = false
	        next
	      end
	      # valid closed p tag. no p tags left
	      if(firstp.nil? and not firstep.nil?)
	        processed << text
	        text = ""
	        inp = false
	        next
        end
        # unclosed p tag
        # either no closing at all or closing later than next opening
        if(firstep.nil? or firstep > firstp)
          # insert text until the p tag and </p> tag
          processed << text.slice(0...firstp)
          processed << "</p>\n"
          text = text.slice(firstp, text.length)
          inp = false
          next
        end
        # properly closed tag
        if(firstep < firstp)
          # find the end of the ep
          endep = text.index(">", firstep)
          # move over the whole ep
          processed << text.slice(0..endep)
          text = text.slice(endep + 1, text.length)
          inp = false
          next
        end
      else
        # not in p
        # find p
        firstp = text.index(/<\s*p/)
        # no ps at all
        if(firstp.nil?)
          processed << text
          text = ""
        else
          # found a p
          # find its end
          endp = text.index(">", firstp)
          processed << text.slice(0..endp)
          inp = true
          text = text.slice(endp + 1, text.length) 
        end
          
      
      # end if inp
      end
	  # end until text.empty?
    end
    processed << '</p>' if(inp)
    return processed
  end
end
