class InSeason
  module Helpers
    def current_line
      offset = (Time.now.yday / 365.0 * 500).to_i + 1
      offset -= 1 if Date.today.leap? && offset > 60
      "<img src='images/current-pixel.png' class='current-line' style='left: #{offset}px'>"
    end
  end
end
