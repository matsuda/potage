__DIR__ = File.dirname(__FILE__)

require 'rubygems'
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
end

def require_or_load(file)
  development? ? load(file) : require(file)
end

__MODEL_DIR__ = 'models'
# $LOAD_PATH.unshift(File.dirname(__FILE__) + '/models')
$LOAD_PATH.unshift(File.join(__DIR__, __MODEL_DIR__))
require_or_load File.join(__MODEL_DIR__, 'post.rb')

# 
# Helpers
# 
helpers do
  def date_format(date)
    date && date.strftime("%Y/%m/%d %H:%M")
  end
  
  def authorized?
    true
    # halt 401, 'Not Autorized'
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
