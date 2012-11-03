class InSeason
  module Helpers
    def current_line
      offset = (InSeason.today / 365.0 * 500).to_i + 1
      "<img src='images/current-pixel.png' class='current-line' style='left: #{offset}px'>"
    end

    def season_bars(crop)
      seasons = crop.seasons.sort_by{|s| s[0]}
      seasons.map do |season|
        if season == seasons.first
          padding = (season[0] / 365.0 * 500).to_i
        else
          prev_season = seasons[seasons.index(season) - 1]
          padding = ((season[0] - (prev_season[0] + prev_season[1])) / 365.0 * 500).to_i
        end

        width = (season[1] / 365.0 * 500).to_i

        "<div class='season-bar-inner#{' in-season' if crop.current_season == season}' style='width: #{width}px; margin-left: #{padding}px'></div>"
      end.join
    end
  end
end
