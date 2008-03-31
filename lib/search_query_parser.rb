require "rubygems"
require "treetop"

module SearchQueryParser

  FORCE_RECOMPILE = false
  SOURCE_PARSER_FILE = "tt_search_query_parser.treetop"
  COMPILED_PARSER_FILE = "_compiled_tt_search_query_parser.rb"

  def self.prepare_parser
      dir = File.expand_path(File.dirname(__FILE__))
      dest = File.join(dir, COMPILED_PARSER_FILE)

      load dest unless recompile_parser
      if File.exist?(dest)
        load dest
      else

      end
  end

  def self.recompile_parser
      dir = File.expand_path(File.dirname(__FILE__))

      source = File.join(dir, SOURCE_PARSER_FILE)
      dest = File.join(dir, COMPILED_PARSER_FILE)
      # see if we need recompile (if we have the file and it's more recent than source)
      if FORCE_RECOMPILE or !File.exist?(dest) or (File.mtime(dest) < File.mtime(source))
         opts =  "\"#{source}\" -o \"#{dest}\""
         cmd = /mswin/ =~ RUBY_PLATFORM ? "tt.bat" : "tt"
         puts "Executing: #{cmd} #{opts}"
         system("#{cmd} #{opts}")
         load dest
         return true
      end
      return false
  end



  def self.build_ferret_query(query)
    recompile_parser

    parser = TTSearchQueryParser.new
    
    resultNode = parser.parse(query.strip)
    result = ""
    
    result = resultNode.value unless resultNode.nil?
    
    puts "result: " + result

    return result
  end

end
