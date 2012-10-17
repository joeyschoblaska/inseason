class InSeason
  module Helpers
    def current_pixel
      offset = ((Time.now.yday - 1) / 365.0 * 500).to_i
      "<img src='images/current-pixel.png' class='current-line' style='left: #{offset}px'>"
    end
  end
end
