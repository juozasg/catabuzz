require "test/unit"
require "../../lib/search_query_parser.rb"

class QueryParserTest < Test::Unit::TestCase
  def setup
      SearchQueryParser.prepare_parser
  end
  # Replace this with your real tests.
  def test_run_method
  	#s = SearchQueryParser.build_ferret_query("T")
  	#s = SearchQueryParser.build_ferret_query("")
    assert true
  end

  def test_combos
    q = SearchQueryParser.build_ferret_query("TW")
    assert_equal "days:TW", q
    
  	q = SearchQueryParser.build_ferret_query("ADV101")
    assert_equal "code:ADV101", q
    
    q = SearchQueryParser.build_ferret_query("MTR ADV101")
    assert_equal "days:MTR code:ADV101", q
    
    q = SearchQueryParser.build_ferret_query("ADV101 t")
    assert_equal "code:ADV101 days:T", q
    

  end
end
