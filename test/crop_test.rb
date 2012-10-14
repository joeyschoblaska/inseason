require './test/test_helper'

class CropTest < Test::Unit::TestCase
  def test_parse_season_one_month
    assert_equal InSeason::Crop.parse_season('january'), [1, 31]
  end

  def test_parse_season_one_month_through_second
    assert_equal InSeason::Crop.parse_season('january through march'), [1, 90]
  end

  def test_parse_season_one_month_and_second
    assert_equal InSeason::Crop.parse_season('june and july'), [152, 61]
  end
end
