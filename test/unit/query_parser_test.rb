require "test/unit"
require "../../lib/search_query_parser.rb"

class QueryParserTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_run_method
  	s = SearchQueryParser.build_ferret_query("T")
  	s = SearchQueryParser.build_ferret_query("")
    assert true
  end

  def test_days
  	q = SearchQueryParser.build_ferret_query("T")
    assert_equal q, "days:T"
  end
end
