class InSeason < Sinatra::Base
  require './lib/crop'
  require './lib/helpers'

  helpers InSeason::Helpers

  get '/' do
    @crops = Crop.load('il')
    haml :index, :format => :html5
  end
end
