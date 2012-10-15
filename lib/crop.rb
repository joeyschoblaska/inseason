class InSeason
  class Crop
    def self.load(state)

    end

    def self.parse_season(season)
      periods = {
        'january' =>   {:start => 1,   :duration => 31},
        'february' =>  {:start => 32,  :duration => 28},
        'march' =>     {:start => 60,  :duration => 31},
        'april' =>     {:start => 91,  :duration => 30},
        'may' =>       {:start => 121, :duration => 31},
        'june' =>      {:start => 152, :duration => 30},
        'july' =>      {:start => 182, :duration => 31},
        'august' =>    {:start => 213, :duration => 31},
        'september' => {:start => 244, :duration => 30},
        'october' =>   {:start => 274, :duration => 31},
        'november' =>  {:start => 305, :duration => 30},
        'december' =>  {:start => 335, :duration => 31},
        'winter' =>    {:start => 356, :duration => 88},
        'spring' =>    {:start => 79,  :duration => 93},
        'summer' =>    {:start => 172, :duration => 93},
        'fall' =>      {:start => 265, :duration => 91},
        'autumn' =>    {:start => 265, :duration => 91}
      }

      return [periods[season][:start], periods[season][:duration]] if season.split(/ /).size == 1

      season.gsub!(' into ', ' through mid-')
      p1, extent, p2 = season.split(/ /)

      # for the first period, use modifiers to get the right half of the range
      if p1.match(/mid-/)
        p1 = periods[p1.gsub('mid-', '')]
        p1[:start] += p1[:duration] / 2
        p1[:duration] = p1[:duration] / 2
      else
        p1 = periods[p1]
      end

      # for the second period, use modifiers to get the left half of the range
      if p2.match(/mid-/)
        p2 = periods[p2.gsub('mid-', '')]
        p2[:duration] = p2[:duration] / 2
      else
        p2 = periods[p2]
      end

      p2[:start] += 365 if p2[:start] < p1[:start]

      if %w(through and).include?(extent)
        return[p1[:start], p2[:start] + p2[:duration] - p1[:start]]
      end

      raise "Could not parse season: #{season}"
    end
  end
end
