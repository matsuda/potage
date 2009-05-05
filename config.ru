set :run, false
set :environment, :production
set :views, 'views'

require 'potage'
run Sinatra::Application
