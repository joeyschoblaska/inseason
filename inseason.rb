class InSeason < Sinatra::Base
  helpers do
    def month_bars
      width = 703
      offset = -(width/365.0 * (Time.now.yday - 1) - width/2).to_i
      "<img class='month-bars' src='images/month-bars.png' style='left: #{offset}px'>" +
      "<img class='month-bars' src='images/month-bars.png' style='left: #{offset + width}px'>"
    end
  end

  get '/' do
    haml :index, :format => :html5
  end
end
