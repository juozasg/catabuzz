require "rubygems"
require "treetop"

$recompile_parser = false
FORCE_RECOMPILE = false
  
module SearchQueryParser
  
  def self.parse_query_terms(query)
    query = query.clone
    
    query.gsub!("\n", " ")
    query.gsub("\r", "")
    
    # full ranges: 1200-1800
    terms = {
      :time_ranges => [],
      :start_times => [],
      :end_times => [],
      :strings => [],
      :weekdays => [],
      :code => [],
      :names => [],
      :department_names => []
    }
    
    ranges_re = /(\s|^)(\d{3,4}\s*-\s*\d{3,4})(\s|$|;)/
    while ranges_re =~ query
      match = $1 + $2 + $3
      md = $~  
      range = md[2].split("-")
      terms[:time_ranges] << range
      query.gsub!(match, " ")
    end
    
    # left ranges: -2000
    left_ranges = []
    left_ranges_re = /(\s|^)(\d{3,4}\s*-)(\s|$|[:alpha:]|_|;)/
    while left_ranges_re =~ query
      match = $1 + $2 + $3
      md = $~
      terms[:start_times] << md[2].gsub(/(-|\s)/, "")
      query.gsub!(match, " " + md[3])
    end
    
    # right ranges: 1200-
    right_ranges = []
    right_ranges_re = /(\s|$|[:alpha:]|_|;)(-\s*\d{3,4})(\s|$)/
    while right_ranges_re =~ query
      match = $1 + $2 + $3
      md = $~
      terms[:end_times] << md[2].gsub(/(-|\s)/, "")
      query.gsub!(match, md[1] + " ")
    end
  
    # qouted strings: "lalala" 'lala'
    strings = []
    strings_re = /(["'])(.*?)(\1)/
    while strings_re =~ query
      match = $1 + $2 + $3
      terms[:strings] << $2
      query.gsub!(match, " ")
    end
    
    # classify words into: codes, class names, weekdays, department names

    words = query.squeeze(" ").strip.split(/\s/)
    puts words.inspect
    
    days_order = "MTWRFS".split("")
    words.each { |word|
      case word
      when /^([MTWRFS]+)$/i
        days = $1.upcase.split("").uniq
        terms[:weekdays] << days.sort_by { |d| days_order.index(d) }.join("")
      when /^TBA$/i
        terms[:weekdays] << "TBA"
      when /(\w{2,5}\d{2,5}\w{0,3})/
        terms[:codes] << $1.upcase
      when /([A-Z]{2,})/
        terms[:department_names] << $1
      else
        terms[:names] << word
      end
    }
    return terms
  end
  
  def self.build_query(terms, problems)
    query = ""
    
    terms = {
      :time_ranges => [],
      :start_times => [],
      :end_times => [],
      :strings => [],
      :weekdays => [],
      :code => [],
      :names => [],
      :department_names => []
    }
    
    terms[:time_ranges].each { |range|
      s = range[0].to_i
      e = range[1].to_i
      
      s = 0 if s < 0
      s = 2400 if s > 2400
      
      e = 0 if e < 0
      e = 2400 if e > 2400
      
      if s < e
        query += " end_time: <= #{time}"
      end
    }
      
    terms[:start_times].each { |str| 
      time = str.to_i
      time = 0 if time < 0
      time = 2400 if time > 2400
      query += " start_time: >= #{time}"
    }
    
    terms[:end_times].each { |str|
      time = str.to_i
      time = 0 if time < 0
      time = 2400 if time > 2400
      query += " end_time: <= #{time}"
    }
    
    
    query += ""
    
    
    return query.strip
  end
  
  def self.build_ferret_query(query)
    
    terms = parse_query_terms(query)
    build_query(terms)
    puts terms.inspect


    # query.scan(/(\s|^)(\d{3,4}-\d{3,4})(\s|$)/) { |ws1, range, ws2| ranges << range}
    # query.gsub!(/\d{3,4}?-\d{3,4}?/, "")
    
    # puts "left ranges: " + left_ranges.inspect
    # puts "right ranges: " + right_ranges.inspect
    # puts "ranges: " + ranges.inspect
    # puts "strings: " + strings.inspect
    # puts "weekdays: " + weekdays.inspect
    # puts "codes: " + codes.inspect
    # puts "class_names: " + class_names.inspect
    # puts "department_names: " + department_names.inspect
    
 
    
    # puts "query: " + query
    
    #parser = TokenizerParser.new

    #resultNode = parser.parse(query.strip)
    #puts resultNode.inspect
    result = "(no match)"

    #result = resultNode.value unless resultNode.nil?

    #puts result.inspect
  end

end
