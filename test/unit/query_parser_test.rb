require "test/unit"
require "../../lib/search_query_parser.rb"

class QueryParserTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_truth
  	s = SearchQueryParser.build_ferret_query("lala")
    assert true
  end
end
