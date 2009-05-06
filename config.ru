# require '/home/USERNAME/.gem/ruby/1.8/gems/rack-<VERSION-OF-RACK-GEM-YOU-HAVE-INSTALLELD>/lib/rack.rb'
#  require '/home/USERNAME/.gem/ruby/1.8/gems/sinatra-<VERSION-OF-SINATRA-GEM-YOU-HAVE-INSTALLELD>/lib/sinatra.rb'

# $LOAD_PATH << '/home/mat5uda/.gems/gems'
ENV['GEM_PATH'] = '/home/mat5uda/.gems:/usr/lib/ruby/gems/1.8'

require 'rubygems'
require 'sinatra
require 'potage'

set :run, false
set :environment, :production
set :views, 'views'

run Sinatra::Application
