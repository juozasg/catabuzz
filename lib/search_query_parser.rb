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
      if FORCE_RECOMPILE or !File.exist?(dest) or (File.atime(dest) < File.atime(source))
         opts =  "\"#{source}\" -o \"#{dest}\""
         cmd = /mswin/ =~ RUBY_PLATFORM ? "tt.bat" : "tt"
         puts "Executing: #{cmd} #{opts}"
         exec("#{cmd} #{opts}")
         load dest
         return true
      end
      return false
  end



  def self.build_ferret_query(query)
    recompile_parser

    parser = TTSearchQueryParser.new
    puts "parsing: [#{query}]"
    puts parser.parse(query).inspect

    result = ""

    tokens = {}
    # split the query string into tokens

    for token in query.split(/,|\s/) do
      next if token.nil? or token.empty?
  
      case token
      when /[MTWRFS]+/
        tokens[:days] = token
      end
  
  
    end

    # collect ferret arguments
    unless tokens[:days].nil?
      result << " days:#{tokens[:days]}"
    end

    return result.strip
  end

end
