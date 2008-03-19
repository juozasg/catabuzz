module SearchQueryParser

  FORCE_RECOMPILE = false

  def self.build_ferret_query(query)
    recompile_parser

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


  def self.recompile_parser
      dir = File.expand_path(File.dirname(__FILE__))

      source = File.join(dir, "search_query_parser.treetop")
      dest = File.join(dir, "compiled_search_query_parser.rb")
      # see if we need recompile (if we have the file and it's more recent than source)
      if FORCE_RECOMPILE or !File.exist?(dest) or (File.atime(dest) < File.atime(source))
         opts =  "\"#{source}\" -o \"#{dest}\""
         cmd = /mswin/ =~ RUBY_PLATFORM ? "tt.bat" : "tt"
         puts "Executing: #{cmd} #{opts}"
         exec("#{cmd} #{opts}")
      end

  end
end
