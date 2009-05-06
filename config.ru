# 
# installing local gems to $HOME/.gems on DreamHost
# http://wiki.dreamhost.com/RubyGems
# 
# ENV['GEM_PATH'] = ENV['HOME'] + '/.gems'
ENV['GEM_PATH'] = File.expand_path('~/.gems') + ':/usr/lib/ruby/gems/1.8'

require 'potage'

set :run, false
set :environment, :production
set :views, 'views'

run Sinatra::Application
