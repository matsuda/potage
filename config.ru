ENV['GEM_PATH'] = File.expand_path('~/.gems') + ':/usr/lib/ruby/gems/1.8'

require 'rubygems'
require 'potage'

set :run, false
set :environment, :production
set :views, 'views'

run Sinatra::Application
