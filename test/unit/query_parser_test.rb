require "test/unit"
require "../../lib/search_query_parser.rb"

class QueryParserTest < Test::Unit::TestCase
  def setup
      SearchQueryParser.prepare_parser
  end
  # Replace this with your real tests.
  def test_run_method
    return
    s = SearchQueryParser.build_ferret_query("T")
    s = SearchQueryParser.build_ferret_query("")
    assert true
  end

  def test_daysofweek
    return
    days = ["M", "T", "W", "R", "F", "S"]
    # test upper and lower case
    for d in days do
      assert_equal "days:#{d}", SearchQueryParser.build_ferret_query("#{d}")
      assert_equal "days:#{d}", SearchQueryParser.build_ferret_query("#{d.downcase}")
    end

    # test combos
    combos = ["mTr", "Mt", "MFs", "mfS", "MTWRFS", "mtwrfs", "mTwRfS", "MtWrFs", "TS", "ts"]

    for c in combos do
      assert_equal "days:#{c.upcase}", SearchQueryParser.build_ferret_query("#{c}")
    end

    # test TBAs
    tbas = ["TBA", "tba", "Tba", "tBa", "tbA", "TBa", "tBA", "TbA"]
    for t in tbas do
      assert_equal "days:#{t.upcase}", SearchQueryParser.build_ferret_query("#{t}")
    end

  end

  def test_codes
    codes = ["LING101", "A1", "A1b", "bob999d"]
    for c in codes do
      assert_equal "code:#{c.upcase}", SearchQueryParser.build_ferret_query("#{c}")
    end
  end
  

  def test_combos
  	q = SearchQueryParser.build_ferret_query("ADV101")
    assert_equal "code:ADV101", q
    
    q = SearchQueryParser.build_ferret_query("MTR ADV101")
    assert_equal "days:MTR code:ADV101", q
    
    q = SearchQueryParser.build_ferret_query("ADV101 t")
    assert_equal "code:ADV101 days:T", q
  end

end
