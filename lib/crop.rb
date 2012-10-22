class InSeason
  class Crop
    attr_accessor :name, :seasons

    def initialize(options = {})
      @name = options[:name]
      @seasons = options[:seasons].map{|s| InSeason::Crop.parse_season(s)}
    end

    def in_season?
      !!current_season
    end

    def year_round?
      seasons.any? do |season|
        season[0] == 1 && season[1] == 365
      end
    end

    def current_season
      today = (Date.today.leap? && Time.now.yday > 6) ? Time.now.yday - 1 : Time.now.yday
      seasons.find do |season|
        season[0] <= today && today <= (season[0] + season[1] - 1)
      end
    end

    def season_remaining
      return 0 unless in_season?

      today = (Date.today.leap? && Time.now.yday > 6) ? Time.now.yday - 1 : Time.now.yday
      current_season[0] + current_season[1] - today
    end

    def <=>(other)
      if in_season? && other.in_season?
        if season_remaining == other.season_remaining
          name <=> other.name
        else
          season_remaining <=> other.season_remaining
        end
      elsif in_season? && !other.in_season?
        -1
      else
        name <=> other.name
      end
    end

    def self.load(state)
      yaml = YAML::load(File.open("config/crops/#{state}.yml"))
      yaml.map{|k, v| self.new(:name => k, :seasons => v)}.sort
    end

    def self.parse_season(season)
      periods = {
        'january' =>    {:start => 1,   :duration => 31},
        'february' =>   {:start => 32,  :duration => 28},
        'march' =>      {:start => 60,  :duration => 31},
        'april' =>      {:start => 91,  :duration => 30},
        'may' =>        {:start => 121, :duration => 31},
        'june' =>       {:start => 152, :duration => 30},
        'july' =>       {:start => 182, :duration => 31},
        'august' =>     {:start => 213, :duration => 31},
        'september' =>  {:start => 244, :duration => 30},
        'october' =>    {:start => 274, :duration => 31},
        'november' =>   {:start => 305, :duration => 30},
        'december' =>   {:start => 335, :duration => 31},
        'winter' =>     {:start => 356, :duration => 88},
        'spring' =>     {:start => 79,  :duration => 93},
        'summer' =>     {:start => 172, :duration => 93},
        'fall' =>       {:start => 265, :duration => 91},
        'autumn' =>     {:start => 265, :duration => 91},
        'year-round' => {:start => 1, :duration => 365}
      }

      # for single periods like "june", "winter"
      return [periods[season][:start], periods[season][:duration]] if season.split(/ /).size == 1

      season.gsub!(' into ', ' through mid-')
      p1, extent, p2 = season.split(/(?<!late|early) /)

      # for single periods with a modifier like "early june", "late winter"
      if p2.nil?
        if p1.match(/^late /)
          p = periods[p1.gsub(/^late /, '')]
          return [p[:start] + (p[:duration] * 0.75).to_i, p[:duration] / 4]
        elsif p1.match(/^early /)
          p = periods[p1.gsub(/^early /, '')]
          return [p[:start], (p[:duration] / 4).to_i]
        end
      end

      # for the first period, use modifiers to get the right half of the range
      if p1.match(/mid-/)
        p1 = periods[p1.gsub(/mid-/, '')]
        p1[:start] += p1[:duration] / 2
        p1[:duration] = p1[:duration] / 2
      elsif p1.match(/^late /)
        p1 = periods[p1.gsub(/^late /, '')]
        p1[:start] += (p1[:duration] * 0.75).to_i
        p1[:duration] = p1[:duration] / 4
      elsif p1.match(/^early /)
        p1 = periods[p1.gsub(/^early /, '')]
        p1[:start] += p1[:duration] / 4
        p1[:duration] = (p1[:duration] * 0.75).to_i
      else
        p1 = periods[p1]
      end

      # for the second period, use modifiers to get the left half of the range
      if p2.match(/mid-/)
        p2 = periods[p2.gsub(/mid-/, '')]
        p2[:duration] = p2[:duration] / 2
      elsif p2.match(/^late /)
        p2 = periods[p2.gsub(/^late /, '')]
        p2[:duration] = (p2[:duration] * 0.75).to_i
      elsif p2.match(/^early /)
        p2 = periods[p2.gsub(/^early /, '')]
        p2[:duration] = p2[:duration] / 4
      else
        p2 = periods[p2]
      end

      p2[:start] += 365 if p2[:start] < p1[:start]

      if %w(through and).include?(extent)
        return[p1[:start], p2[:start] + p2[:duration] - p1[:start]]
      end

      raise 'Could not parse season information'
    rescue Exception => e
      puts "Error parsing season: #{season}"
      raise e
    end
  end
end
