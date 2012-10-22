require './test/test_helper'

class CropTest < Test::Unit::TestCase
  # smoke test to ensure that all data is parse-able
  def test_data
    Dir.foreach('config/crops/') do |file|
      next unless file.match(/\w\w\.yml/)
      InSeason::Crop.load(file.gsub('.yml', ''))
    end

    assert_equal 1, 1
  end

  def test_parse_season_one_month
    assert_equal InSeason::Crop.parse_season('january'), [1, 31]
  end

  def test_parse_season_one_month_through_second
    assert_equal InSeason::Crop.parse_season('january through march'), [1, 90]
  end

  def test_parse_season_one_month_and_second
    assert_equal InSeason::Crop.parse_season('june and july'), [152, 61]
  end

  def test_parse_season_months_that_wrap_year_boundary
    assert_equal InSeason::Crop.parse_season('december through february'), [335, 90]
  end

  def test_parse_season_one_season_through_second
    assert_equal InSeason::Crop.parse_season('spring through summer'), [79, 186]
  end

  def test_mid_modifiers
    assert_equal InSeason::Crop.parse_season('mid-february through march'), [46, 45]
    assert_equal InSeason::Crop.parse_season('february through mid-march'), [32, 43]
    assert_equal InSeason::Crop.parse_season('mid-february through mid-march'), [46, 29]
  end

  def test_late_modifiers
    assert_equal InSeason::Crop.parse_season('late february through march'), [53, 38]
    assert_equal InSeason::Crop.parse_season('february through late march'), [32, 51]
    assert_equal InSeason::Crop.parse_season('late february through late march'), [53, 30]
  end

  def test_early_modifiers
    assert_equal InSeason::Crop.parse_season('early february through march'), [39, 52]
    assert_equal InSeason::Crop.parse_season('february through early march'), [32, 35]
    assert_equal InSeason::Crop.parse_season('early february through early march'), [39, 28]
  end

  def test_single_partial_period
    assert_equal InSeason::Crop.parse_season('early january'), [1, 7]
    assert_equal InSeason::Crop.parse_season('late january'), [24, 7]
  end

  def test_year_round
    assert_equal InSeason::Crop.parse_season('year-round'), [1, 365]
  end
end
