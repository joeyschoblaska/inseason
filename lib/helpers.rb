class InSeason
  module Helpers
    def geocoded_state
      return @geocoded_state if @geocoded_state
      state = Geokit::Geocoders::IpGeocoder.geocode(request.ip).state
      @geocoded_state = state ? state.downcase : nil
    end

    def season_bars(crop)
      seasons = crop.seasons.sort_by{|s| s[0]}
      seasons.map do |season|
        highlight =
          crop.current_season == season ||
          crop.in_season? && season[0] == 1 && crop.current_season[0] + crop.current_season[1] > 365

        if season == seasons.first
          padding = (season[0] / 365.0 * 500).to_i
        else
          prev_season = seasons[seasons.index(season) - 1]
          padding = ((season[0] - (prev_season[0] + prev_season[1])) / 365.0 * 500).to_i
        end

        width = (season[1] / 365.0 * 500).to_i

        "<div class='season-bar-inner#{' in-season' if highlight}' style='width: #{width}px; margin-left: #{padding}px'></div>"
      end.join
    end

    def states
      {
        'ak' => 'Alaska',
        'al' => 'Alabama',
        'ar' => 'Arkansas',
        'az' => 'Arizona',
        'ca' => 'California',
        'co' => 'Colorado',
        'ct' => 'Connecticut',
        'de' => 'Delaware',
        'fl' => 'Florida',
        'ga' => 'Georgia',
        'hi' => 'Hawaii',
        'ia' => 'Iowa',
        'id' => 'Idaho',
        'il' => 'Illinois',
        'in' => 'Indiana',
        'ks' => 'Kansas',
        'ky' => 'Kentucky',
        'la' => 'Louisiana',
        'ma' => 'Massachusetts',
        'md' => 'Maryland',
        'me' => 'Maine',
        'mi' => 'Michigan',
        'mn' => 'Minnesota',
        'mo' => 'Missouri',
        'ms' => 'Mississippi',
        'mt' => 'Montana',
        'nc' => 'North Carolina',
        'nd' => 'North Dakota',
        'ne' => 'Nebraska',
        'nh' => 'New Hampshire',
        'nj' => 'New Jersey',
        'nm' => 'New Mexico',
        'nv' => 'Nevada',
        'ny' => 'New York',
        'oh' => 'Ohio',
        'ok' => 'Oklahoma',
        'or' => 'Oregon',
        'pa' => 'Pennsylvania',
        'ri' => 'Rhode Island',
        'sc' => 'South Carolina',
        'sd' => 'South Dakota',
        'tn' => 'Tennessee',
        'tx' => 'Texas',
        'ut' => 'Utah',
        'va' => 'Virginia',
        'vt' => 'Vermont',
        'wa' => 'Washington',
        'wv' => 'West Virginia',
        'wi' => 'Wisconsin',
        'wy' => 'Wyoming'
      }
    end

    def partial(template, options = {})
      options[:layout] = false
      haml(template, options)
    end
  end
end
