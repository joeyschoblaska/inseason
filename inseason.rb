class InSeason < Sinatra::Base
  require './lib/helpers'
  require './lib/crop'

  helpers InSeason::Helpers

  get '/' do
    @state = 'il'
    @crops = Crop.load(@state)
    @year_round = @crops.select{|c| c.year_round?}
    haml :index, :format => :html5
  end

  def self.today
    (Date.today.leap? && Time.now.yday > 59) ? Time.now.yday - 1 : Time.now.yday
  end
end
