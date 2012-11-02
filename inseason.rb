class InSeason < Sinatra::Base
  require './lib/helpers'
  require './lib/crop'

  helpers InSeason::Helpers

  get '/' do
    @crops = Crop.load('il')
    @year_round = @crops.select{|c| c.year_round?}
    haml :index, :format => :html5
  end

  def self.today
    (Date.today.leap? && Time.now.yday > 59) ? Time.now.yday - 1 : Time.now.yday
  end
end
