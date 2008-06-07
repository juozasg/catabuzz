require "ostruct"
require 'rubygems'
require 'hpricot'
require 'open-uri'


class CatalogScraper
	
	def cutContentPortionFromDoc(doc)
		text = doc.inner_html
		md = /<!-- content starts here -->(.*?)<!-- content ends here -->/m.match(text)
		
		return Hpricot(md[1])
	end
	
	def scrapeDepartmentList(url)
		# results << OpenStruct.new(:name => "ADVERTISING", :url => "http://info.sjsu.edu/web-dbgen/soc-fall-courses/d17441.html")
		results = []
		
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
		# result = OpenStruct.new(:fullName => "Introduction To Linguistics", :description => "SCIENTIFIC study of lang...", 
		# 							:prerequisites => "...", :corequisites => "...", :misc => "...", :units => 3)
		
		result = OpenStruct.new
		begin
			doc = cutContentPortionFromDoc(Hpricot(open(url)))
			result.fullName = doc.at(:h4).inner_text
			
			# find description text and units text nodes
			ps = doc.search(:p)
			descNode = doc.at("p:nth-child(1)")
			unitsNode = doc.at("p:nth-child(2)")

			# get text from nodes
			desc = descNode.inner_text
			result.units = /Units.*(\d+)/m.match(unitsNode.inner_text)[1].to_i
			
			# split up description text			
			parts = desc.to_s.split("\n").reject { |v| v.nil? or v.empty? }
        	result.description = parts[1].to_s
        	result.prerequisites = parts[2].to_s.gsub("Prerequisite:", "").strip
        	result.corequisites = parts[3].to_s.gsub("Corequisite:", "").strip
        	result.misc = parts[4..-1].to_a.join("\n")
        				
		rescue
			# do nothing, will return nil
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
			
			data[key.downcase.to_sym] = val unless (key.empty? or val.split.join.empty?)
		end
		
		# some data is ready, just dump it into result
		result.marshal_load(data)
		
		# rename some stuff
		result.course_section_code = result.code
		
		# convert some stuff
		md = /(\d+)\/(\d+)/.match(result.enrollment)
		result.enrollment_current = md[1].to_i
		result.enrollment_max = md[2].to_i
		
		md = /(\d+)\s+(\d+)/.match(result.time)
		
		# check for unannounced times
		unless /TBA/ =~ result.time
			result.start_time = md[1].to_i
			result.end_time = md[2].to_i
		else
			result.start_time = result.end_time = nil
		end
		
		# delete extra stuff from result
		[:time, :enrollment, :dates, :title, :units, :"ge designator", :code, :schedule].map {|s| result.delete_field(s)}
		
		return result
	end
	
	def extractDepartmentItems(rootDoc)
	  # results << OpenStruct.new(:href => '/web-dbgen/soc-spring-courses/d22710.html', name => 'ADVERTISING')
	  
	  # scrape department list
		results = []
		
		(rootDoc/"table tr").each { |row|
			a = td.at("td a")
			results << OpenStruct.new(:href => a["href"], :name => a.inner_text)
		}
	  
	  return results
  end
	
	
	def scrapeAndCreateModel(scheduleRootUrl, sjsuRootUrl)
		#scheduleRootUrl: "http://info.sjsu.edu/web-dbgen/soc-fall-courses/"
		#sjsuRootUrl: "http://info.sjsu.edu/"
		rootDoc = cutContentPortionFromDoc(Hpricot(open(scheduleRootUrl + "/all-departments.html")))
		
		scheduleName = rootDoc.at(:h3).inner_text
		
		schedule = Schedule.create(:name => scheduleName)
		schedule.save!
		
		depList = extractDepartmentItems(rootDoc)
		
		# scrape department list
		depList.each_with_index { |depItem, i|
		  			
			puts "(#{i + 1} of #{depList.length}) -- #{depItem.name}"
			
			#departments can be listed twice, so first check for existing ones
			department = Department.find(:first, :conditions => ["name = ?", departmentName])
			if(department.nil?)
		    department = Department.create(:name => departmentName)
	    end
	    
			# get the list of sections for this department
			courseSectionList = scrapeCourseSectionList(sjsuRootUrl + depItem.href)
			
			# set the department code if we don't have one
			if department.code.nil?
		  	unless courseSectionList[0].nil?
  			  department.code = courseSectionList[0].departmentCode
  		  else
  		    department.code = "undefined"
  		  end
  		  department.save!
      end
			
			courseCodesAndNames = courseSectionList.collect {|e| [e.courseCode, e.shortName]}
			
			# for all the new course codes we have seen
			# we should scrape the description and create a course if it doesn't exist
			deparmentCourseCodesAndNames.each do |code, shortName|
				course = Course.find(:first, :conditions => ["code =?", code])
				if course.nil?
					courseData = scrapeCourseDescription(sjsuRootUrl + "/web-dbgen/catalog/courses/" + code + ".html")
					name = (courseData.fullName or shortName)
					
					course = Course.create(:name => name, :code => code, :description => courseData.description, 
									:prerequisites => courseData.prerequisites, :corequisites => courseData.corequisites,
									:misc => courseData.misc, :units => courseData.units)
				end
				course.department = department
				course.save!
			end
			
			# now we have Department > Course relationship complete (for this department)
			# do each course section
			departmentCourseSectionList.each do |sectionEntry|
				# OpenStruct.new(:code => "ADV091", :shortName => "Intro Advertising", :courseSectionUrl => "/web-dbgen/soc-fall-courses/c667543.html")
				courseSectionInfo = scrapeCourseSection(sjsuRootUrl + sectionEntry.courseSectionUrl)
				
				# include the url for updating enrollment
				courseSectionInfo.update_url = sectionEntry.courseSectionUrl
				
				courseSection = CourseSection.new(courseSectionInfo.marshal_dump)
				
				# find the course info for this section
				course = Course.find(:first, :conditions => ["code =?", sectionEntry.courseCode])
				
				courseSection.course = course
				courseSection.schedules << schedule
				courseSection.save!
				
				
			end
			
			print "\n"
			curDep += 1
		}
					
			
	end
	
end
