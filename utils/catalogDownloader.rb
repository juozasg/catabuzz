require "ostruct"
require 'rubygems'
require 'hpricot'
require 'uri'
require 'open-uri'
require 'pathname'

require 'catalogScraper.rb'

class CatalogDownloader  
  def initialize(remoteHost, remoteLocation, localHostRoot = "./downloads")  
  	#remoteHost: "http://info.sjsu.edu/"
  	#remoteLocation: "/web-dbgen/soc-fall-courses/"
  	
  	@remoteHost = remoteHost
  	@remoteLocation = remoteLocation
  	@localHostRoot = localHostRoot
  	@remoteUrl = URI.join(@remoteHost, @remoteLocation)
  end
  
  def download
    depListUrl = "/all-departments.html"
    
    scraper = CatalogScraper.new

    # get the read and write locations for the url
    depListRemoteUrl = URI.join(@remoteUrl, depListUrl).to_s
    depListLocalUrl = File.join(@localHostRoot, @remoteLocation, depListUrl)

    print "Downloading list from:#{depListRemoteUrl}\nto\n#{depListLocalUrl}"
    $STDOUT.flush
    # write the local copy
    getPage(depListRemoteUrl, depListLocalUrl)
    
    puts "done"

		# departmentList << OpenStruct.new(:href => '/web-dbgen/soc-spring-courses/d22710.html', name => 'ADVERTISING')
		depList = scraper.scrapeDepartmentItems(depListLocalUrl)
		
	  # for each department: save department file (section list); save each section; save each course
	  depList.each_with_index { |dep, i|
	    puts "Processing #{i + 1} of #{depList.length} -- #{dep.name}"
	    
	    sectionListRemoteUrl = URI.join(@remoteHost, dep.href).to_s
	    sectionListLocalUrl = File.join(@localHostRoot, dep.href)
	    
	    # download department file (section list)
	    getPage(sectionListRemoteUrl, sectionListLocalUrl)

	    # get the section list and download each section
	    sectionList = scraper.scrapeCourseSectionList(sectionListLocalUrl)
	    
	    # avoid redownloading files
	    # when we process the section list.
	    # since several sections (in the same list) have the same course
	    # and the same course can be thought in different departments
	    # remember what we've already downloaded
    	@courseFilesDownloaded = {}
	    processSectionList(sectionList)
	  }  
	  
	  puts "Downloader...Done!"
	end
	
	def processSectionList(sectionList)
	  courseCatalogUrl = "/web-dbgen/catalog/courses/"
	  remoteCourseCatalogUrl = URI.join(@remoteHost, courseCatalogUrl).to_s
	  
	  sectionList.each_with_index { |section, i|

	    # download the section file (course section tabular data)
	    # get paths
	    sectionRemoteUrl = URI.join(@remoteHost, section.courseSectionUrl).to_s
	    sectionLocalUrl = File.join(@localHostRoot, sectionLocalUrl.courseSectionUrl)
	    
	    # get the data
	    getPage(sectionRemoteUrl, sectionLocalUrl)
	 
  	  # now get the course data
  	  # get the urls
  	  courseRemoteUrl = URI.join(remoteCourseCatalogUrl, section.courseCode + ".html").to_s
  	  courseLocalUrl = File.join(@localHostRoot, courseCatalogUrl, section.courseCode + ".html").to_s

	    # get the data if we don't have it
	    unless @courseFilesDownloaded[courseRemoteUrl]
  	    getPage(courseRemoteUrl, courseLocalUrl)
  	    @courseFilesDownloaded[courseRemoteUrl] = true
	    end
      
	  }
	  
  end
  
  def getPage(remoteUrl, localUrl)
    File.open(localUrl, "w+") { |f|
  	    data = open(remoteUrl).read
  	    f.write(data)
  	}
  end
	
end


# only run as standalone
if __FILE__ == $0
  downloader = CatalogDownloader.new("http://info.sjsu.edu/", "/web-dbgen/soc-fall-courses/", "./downloads")
  downloader.download
end