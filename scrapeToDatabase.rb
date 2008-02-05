require "catalogScraper.rb"
require "catalogerSchema.rb"

# only run as standalone
if __FILE__ == $0
	# -k - keep existing tables
	unless ARGV[0] == "-k"
		begin
			CatalogerSchema.dropTables
		rescue
		end
		CatalogerSchema.createTables
	end

	CatalogScraper.new.scrapeAndCreateModel("http://info.sjsu.edu/web-dbgen/soc-fall-courses/", "http://info.sjsu.edu/")
end