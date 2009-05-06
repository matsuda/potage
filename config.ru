ENV['GEM_PATH'] = '/home/mat5uda/.gems:/usr/lib/ruby/gems/1.8'

# require 'rubygems'
# require 'sinatra'
require 'potage'

set :run, false
set :environment, :production
set :views, 'views'

run Sinatra::Application
