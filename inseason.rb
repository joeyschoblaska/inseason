class InSeason < Sinatra::Base
  get '/' do
    haml :index
  end
end
