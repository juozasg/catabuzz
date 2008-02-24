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
		# results << OpenStruct.new(:code => "ADV091", :shortName => "Intro Advertising", :courseSectionUrl => "/web-dbgen/soc-fall-courses/c667543.html")
		results = []
		
		doc = cutContentPortionFromDoc(Hpricot(open(url)))
		
		lectureListTable = (doc/"table")[2]
		
		unless lectureListTable.nil?
			lectureListTable.search("tr") do |row|
				cols = row.search("td")
				a = cols[0].at("a")
				
				courseSectionUrl = a["href"]		
				courseCode = a.inner_text.split(" ").join("")
				courseShortName = cols[2].inner_text
				
				os = OpenStruct.new(:code => courseCode, :shortName => courseShortName, :courseSectionUrl => courseSectionUrl)
				
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
		# results << OpenStruct.new(:courseSectionCode => "40033", :footnotes => "73", :section => "01", :type => "LEC", :currentEnrollment => 67,
		# 	 							:maxEnrollment => 70, :days => "MW", :startTime => 900, :endTime => 1015, :location => "DBH 222",
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
		result.courseSectionCode = result.code
		
		# convert some stuff
		md = /(\d+)\/(\d+)/.match(result.enrollment)
		result.enrollmentCurrent = md[1].to_i
		result.enrollmentMax = md[2].to_i
		
		md = /(\d+)\s+(\d+)/.match(result.time)
		puts result.inspect
		
		# check for unannounced times
		unless /TBA/ =~ result.time
			result.startTime = md[1].to_i
			result.endTime = md[2].to_i
		else
			result.startTime = result.endTime = nil
		end
		
		# delete extra stuff from result
		[:time, :enrollment, :dates, :title, :units, :"ge designator", :code, :schedule].map {|s| result.delete_field(s)}
		
		return result
	end
	
	
	def scrapeAndCreateModel(scheduleRootUrl, sjsuRootUrl)
		
		# url: "http://info.sjsu.edu/web-dbgen/soc-fall-courses/all-departments.html"
		doc = cutContentPortionFromDoc(Hpricot(open(scheduleRootUrl + "/all-departments.html")))
		
		scheduleName = doc.at(:h3).inner_text
		
		schedule = Schedule.create(:name => scheduleName)
		schedule.save!
		
		# scrape department list
		depCount = (doc/"table td").length
		curDep = 1
		(doc/"table td").each do |td|
			a = td.at("a")
			
			courseSectionListUrl =  a["href"]
			departmentName =  a.inner_text
			
			print "(#{curDep} of #{depCount}) -- #{departmentName}\t\t"
			STDOUT.flush
			
			#departments can be listed twice, so first check for existing one
			department = Department.find(:all, :conditions => ["name = ?", departmentName]).first
			
			department = Department.create(:name => departmentName) if department.nil?
		
			
			departmentCourseSectionList = scrapeCourseSectionList(sjsuRootUrl + courseSectionListUrl)
	
			deparmentCourseCodesAndNames = departmentCourseSectionList.collect {|e| [e.code, e.shortName]}
			
			# for all the new course codes we have seen
			# we should scrape the description and create a course if it doesn't exist
			deparmentCourseCodesAndNames.each do |code, shortName|
				course = Course.find(:all, :conditions => ["courseCode =?", code]).first
				if course.nil?
					courseData = scrapeCourseDescription(sjsuRootUrl + "/web-dbgen/catalog/courses/" + code + ".html")
					name = (courseData.fullName or shortName)
					
					course = Course.create(:name => name, :courseCode => code, :description => courseData.description, 
									:prerequisites => courseData.prerequisites, :corequisites => courseData.corequisites,
									:misc => courseData.misc, :units => courseData.units)
				end
				course.department = department
				course.save!
			end
			
			# now we have Department > Course relationship complete (for this department)
			# do each course lecture
			departmentCourseSectionList.each do |lectureEntry|
				# OpenStruct.new(:code => "ADV091", :shortName => "Intro Advertising", :courseSectionUrl => "/web-dbgen/soc-fall-courses/c667543.html")
				courseSectionInfo = scrapeCourseSection(sjsuRootUrl + lectureEntry.courseSectionUrl)
				
				# include the url for updating enrollment
				courseSectionInfo.updateURL = lectureEntry.courseSectionUrl
				
				courseSection = CourseSection.new(courseSectionInfo.marshal_dump)
				
				# find the course info for this lecture
				course = Course.find(:all, :conditions => ["courseCode =?", lectureEntry.code]).first
				
				courseSection.course = course
				courseSection.schedules << schedule
				courseSection.save!
				
				#print "."
				#STDOUT.flush
				
			end
			
			print "\n"
			curDep += 1
		end
					
			
	end
	
end
