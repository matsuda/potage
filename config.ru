# 
# installing local gems to $HOME/.gems on DreamHost
# http://wiki.dreamhost.com/RubyGems
# 
# ENV['GEM_PATH'] = ENV['HOME'] + '/.gems'
ENV['GEM_PATH'] = File.expand_path('~/.gems') + ':/usr/lib/ruby/gems/1.8'

require 'rubygems'
require 'vendor/sinatra/lib/sinatra'

set :run, false
set :environment, :production
set :views, 'views'

require 'potage'

run Sinatra::Application
