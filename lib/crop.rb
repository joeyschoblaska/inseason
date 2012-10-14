class InSeason
  class Crop
    def self.load(state)

    end

    def self.parse_season(season)
      periods = { #[day of the year on which period begins, duration in days]
        'january' => [1, 31],
        'february' => [32, 28],
        'march' => [60, 31],
        'april' => [91, 30],
        'may' => [121, 31],
        'june' => [152, 30],
        'july' => [182, 31],
        'august' => [213, 31],
        'september' => [244, 30],
        'october' => [274, 31],
        'november' => [305, 30],
        'december' => [335, 31],
        'winter' => [356, 88],
        'spring' => [79, 93],
        'summer' => [172, 93],
        'fall' => [265, 91],
        'autumn' => [265, 91]
      }

      if season.split(/ /).size == 1 && periods.keys.include?(season)
        return periods[season]
      elsif season.split(/ /).size == 3
        period1, extent, period2 = season.split(/ /)
        period1 = periods[period1]
        period2 = periods[period2]

        case extent
        when 'through', 'and'
          return[period1[0], period2[0] + period2[1] - period1[0]]
        end
      end

      raise "Could not parse season: #{season}"
    end
  end
end
