module SearchQueryParser
  def self.build_ferret_query(query)
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

    return result
  end
end
