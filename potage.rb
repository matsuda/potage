require 'rubygems'
require 'yaml'
require 'sinatra'

# 
# Configuration
# 
configure do
  # enable :sessions
  set :sessions, true
  config = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'config.yml'))
  Blog = OpenStruct.new config["blog"]
  bit = ('0'..'9').to_a + ('A'..'Z').to_a
  Blog.session_key = Array.new(8){ bit[rand(bit.size)] }.join
end

def require_or_load(file)
  development? ? load(file) : require(file)
end

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'models')))
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'models/*.rb'))].sort.each { |lib|
  require_or_load lib 
}

# 
# Helpers
# 
helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def simple_format(text)
    text && h(text).gsub(/\r\n/, "\n").gsub(/\n/, '<br />')
  end

  def date_format(date)
    date && date.strftime("%Y/%m/%d %H:%M:%S")
  end

  def partial(template, options = {})
    options = options.merge!({:layout => false})
    template_engine = options[:template_engine] || 'haml'
    # haml(template.to_sym, options)
    send(template_engine, template.to_sym, options)
  end

  def logged_in?
    # !!session['potage']
    session['potage'] && session['potage'] == Blog.session_key
  end

  def authorized?
    redirect '/auth' and return unless logged_in?
    # halt 401, 'Not Autorized' unless session['potage']
  end

  def authenticate(username, password)
    admin = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'config.yml'))["admin"]
    # session['potage'] = true if username == admin["username"] && password == admin["password"]
    session['potage'] = Blog.session_key if username == admin["username"] && password == admin["password"]
  end
end

before do
  # p session['potage']
end

# 
# Routes
# 
get '/' do
  @post = Post.reverse_order(:updated_at).first
  haml :index
end

get '/posts' do
  @posts = Post.reverse_order(:updated_at)
  haml :posts
end

get '/post/:id' do
  post = Post[params[:id]]
  haml :post, :locals => {:post => post}
end

get '/auth' do
  haml :auth
end

post '/auth' do
  authenticate params[:username], params[:password]
  authorized?
  redirect '/'
end

get '/logout' do
  session['potage'] = nil
  redirect '/'
end

get '/posts/new' do
  authorized?
  post = Post.new
  haml :edit, :locals => {:post => post}
end

post '/posts' do
  authorized?
  post = Post.new :title => params[:title], :body => params[:body]
  begin
    post.save
    redirect "/post/#{post.id}"
  rescue Sequel::ValidationFailed => e
    haml :edit, :locals => {:post => post}
  end
end

get '/feeds' do
  content_type 'application/xml', :charset => 'utf-8'
  builder :index
end
