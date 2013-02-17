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
    assert_equal [1, 31], InSeason::Crop.parse_season('january')
  end

  def test_parse_season_one_month_through_second
    assert_equal [1, 90], InSeason::Crop.parse_season('january through march')
  end

  def test_parse_season_one_month_and_second
    assert_equal [152, 61], InSeason::Crop.parse_season('june and july')
  end

  def test_parse_season_months_that_wrap_year_boundary
    assert_equal [335, 90], InSeason::Crop.parse_season('december through february')
  end

  def test_parse_season_one_season_through_second
    assert_equal [79, 186], InSeason::Crop.parse_season('spring through summer')
  end

  def test_mid_modifiers
    assert_equal [46, 45], InSeason::Crop.parse_season('mid-february through march')
    assert_equal [32, 43], InSeason::Crop.parse_season('february through mid-march')
    assert_equal [46, 29], InSeason::Crop.parse_season('mid-february through mid-march')
  end

  def test_late_modifiers
    assert_equal [53, 38], InSeason::Crop.parse_season('late february through march')
    assert_equal [32, 51], InSeason::Crop.parse_season('february through late march')
    assert_equal [53, 30], InSeason::Crop.parse_season('late february through late march')
  end

  def test_early_modifiers
    assert_equal [39, 52], InSeason::Crop.parse_season('early february through march')
    assert_equal [32, 35], InSeason::Crop.parse_season('february through early march')
    assert_equal [39, 28], InSeason::Crop.parse_season('early february through early march')
  end

  def test_single_partial_period
    assert_equal [1, 7], InSeason::Crop.parse_season('early january')
    assert_equal [24, 7], InSeason::Crop.parse_season('late january')
  end

  def test_year_round
    assert_equal [1, 365], InSeason::Crop.parse_season('year-round')
  end

  def test_splitting_wrapping_seasons
    assert_equal [[1,30]], InSeason::Crop.split_wrapping_season([1,30])
    assert_equal [[1, 2], [363, 3]], InSeason::Crop.split_wrapping_season([363, 5])

  end

  def test_wrapping_periods
    crop = InSeason::Crop.new(:name => 'athelas', :seasons => ['winter', 'summer'])
    Time.stubs(:now).returns(Time.parse('Janaury 1, 2013'))

    assert crop.in_season?
    assert_equal 78, crop.season_remaining
  end

  def test_season_remaining_with_wrapping_periods
    crop = InSeason::Crop.new(:name => 'athelas', :seasons => ['winter', 'summer'])
    Time.stubs(:now).returns(Time.parse('December 25, 2013'))

    assert_equal 85, crop.season_remaining
  end
end
