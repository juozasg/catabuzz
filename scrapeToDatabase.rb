require "catalogScraper.rb"

def drop_db(config)
  case config['adapter']
  when 'mysql'
    ActiveRecord::Base.connection.drop_database config['database']
  when /^sqlite/
    puts "deleting: " + File.join(RAILS_ROOT, config['database'])
    FileUtils.rm_f(File.join(RAILS_ROOT, config['database']))
  when 'postgresql'
    `dropdb "#{config['database']}"`
  end
end

# only run as standalone
if __FILE__ == $0
  
  RAILS_ENV = "development"
  require "config/environment"
  	
	# -k -- keep existing tables
	unless ARGV[0] == "-k"
	  config = ActiveRecord::Base.configurations[RAILS_ENV]
		drop_db(config)
		load(File.join(RAILS_ROOT, "db/schema.rb"))
	end

  #puts Department.find(:first).inspect
	#CatalogScraper.new.scrapeAndCreateModel("http://info.sjsu.edu/web-dbgen/soc-fall-courses/", "http://info.sjsu.edu/")
end