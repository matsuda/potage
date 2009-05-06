require 'potage'

set :run, false
set :environment, :production
set :views, 'views'

run Sinatra::Application
