__DIR__ = File.dirname(__FILE__)

require 'rubygems'
require 'yaml'
require 'sinatra'
require 'sequel'

# 
# Configuration
# 
configure do
  DB = Sequel.connect('sqlite://db/potage.db')
  unless DB.table_exists?(:posts)
    DB.create_table :posts do
      primary_key :id
      String    :title
      String    :body
      DateTime  :created_at
      DateTime  :updated_at
    end
  end

  config = YAML.load_file(File.join(__DIR__, 'config', 'config.yml'))
  Blog = OpenStruct.new config["blog"]
end

def require_or_load(file)
  development? ? load(file) : require(file)
end

$LOAD_PATH.unshift(File.expand_path(File.join(__DIR__, 'models')))
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'models/*.rb'))].sort.each { |lib|
  require_or_load lib 
}

enable :sessions

# 
# Helpers
# 
helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def date_format(date)
    date && date.strftime("%Y/%m/%d %H:%M")
  end
  
  def authorized?
    halt 401, 'Not Autorized' unless session['potage']
  end

  def authenticate(username, password)
    admin = YAML.load_file(File.join(__DIR__, 'config', 'config.yml'))["admin"]
    session['potage'] = true if username == admin["username"] && password == admin["password"]
  end
end

# 
# Routes
# 
get '/' do
  @post = Post.reverse_order(:updated_at).first
  erb :index
end

get '/posts' do
  @posts = Post.reverse_order(:updated_at)
  erb :posts
end

get '/post/:id' do
  @post = Post[params[:id]]
  erb :post
end

get 'auth' do
  erb :auth
end

post 'auth' do
  
  redirect '/'
end

get '/posts/new' do
  authorized?
  post = Post.new
  erb :edit, :locals => {:post => post}
end

post '/posts' do
  authorized?
  post = Post.new :title => params[:title], :body => params[:body]
  begin
    post.save
    redirect "/post/#{post.id}"
  rescue Sequel::ValidationFailed => e
    erb :edit, :locals => {:post => post}
  end
end

get '/feeds' do
  authorized?
  content_type 'application/xml', :charset => 'utf-8'
  builder :index
end
