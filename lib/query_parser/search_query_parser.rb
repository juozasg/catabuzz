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
      :codes => [],
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
  
  def self.build_query_from_terms(terms, problems)
    query = ""
    
    terms = {
      :time_ranges => [],
      :start_times => [],
      :end_times => [],
      :strings => [],
      :weekdays => [],
      :codes => [],
      :names => [],
      :department_names => []
    }
    
    terms[:time_ranges].each do |range|
      s = range[0].to_i
      e = range[1].to_i
      
      s = 0 if s < 0
      s = 2400 if s > 2400
      
      e = 0 if e < 0
      e = 2400 if e > 2400
      
      if s > e
        query += sprintf(" start_time: >= %04d", s)
        query += sprintf(" end_time: <=  %04d", e)
      else
        problems << "#{s}-#{e} time range is bad. First number has to be smaller"
      end
    end
      
    terms[:start_times].each do |str| 
      time = str.to_i
      time = 0 if time < 0
      time = 2400 if time > 2400
      query += sprintf(" start_time: >= %04d", time)
    end
    
    terms[:end_times].each do |str|
      time = str.to_i
      time = 0 if time < 0
      time = 2400 if time > 2400
      query += sprintf(" end_time: <=  %04d", time)
    end
    
    # process strings and names
    name_fragmens = (terms[:strings] + terms[:names]).map { |str| "course_name: #{str}"}
    query += " (" + name_fragmens.join(" OR ") + ")"
    
    terms[:weekdays].each do |days|
      query += " days:#{days}"
    end
    
    # OR together course codes
    code_fragments = terms[:codes].map { |str| "course_code: #{str}"}
    query += " (" + code_fragments.join(" OR ") + ")"
    
    #together departments
    terms[:department_names].each do |dep|
      query += " department_name: *#{str}*"
    end
    
    return query.strip
  end
  
  def self.build_ferret_query(query)
    
    terms = parse_query_terms(query)
    ferret_query = build_query_from_terms(terms)
    
    return ferret_query
   
  end

end
