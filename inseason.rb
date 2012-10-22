class InSeason < Sinatra::Base
  require './lib/crop'
  require './lib/helpers'

  helpers InSeason::Helpers

  get '/' do
    @crops = Crop.load('il')
    @year_round = @crops.select{|c| c.year_round?}
    haml :index, :format => :html5
  end
end
