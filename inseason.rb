class InSeason < Sinatra::Base
  require './lib/helpers'
  require './lib/crop'

  helpers InSeason::Helpers
  helpers Sinatra::Cookies

  set(:cookie_options) do
    {:expires => Time.now + 3600*24*365}
  end

  get '/' do
    redirect to(default_state)
  end

  get '/:state' do |s|
    @state = s.downcase
    cookies[:state] = @state
    crops = Crop.load(@state)
    @year_round = crops.select{|c| c.year_round?}
    @in_season = crops.select{|c| c.in_season? && !c.year_round?}
    @out_of_season = crops.select{|c| !c.in_season?}
    haml :index, :format => :html5
  end

  def self.today
    (Date.today.leap? && Time.now.yday > 59) ? Time.now.yday - 1 : Time.now.yday
  end
end
