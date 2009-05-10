require 'rubygems'
require 'yaml'
# require 'sinatra'
require 'vendor/sinatra/lib/sinatra'
require 'haml'
require 'rdiscount'

# 
# Configuration
# 
configure do
  enable :sessions
  config = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'config.yml'))
  Blog = OpenStruct.new config["blog"]
  Admin = OpenStruct.new config["admin"]
  bit = ('0'..'9').to_a + ('A'..'Z').to_a
  Admin.session_key = Array.new(8){ bit[rand(bit.size)] }.join
end

def require_or_load(file)
  development? ? load(file) : require(file)
end

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'models')))
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'models/*.rb'))].sort.each { |lib|
  require_or_load lib 
}

error do
  e = request.env['sinatra.error']
  puts e.to_s
  puts e.backtrace.join("\n")
  "Application error"
end

# 
# Helpers
# 
helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def date_format(date)
    date && date.strftime("%Y/%m/%d %H:%M:%S")
  end

  def rfc_date(datetime)
    # if datetime.is_a? Time
    #   datetime = DateTime.new(datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, datetime.sec)
    # end
    # datetime
    datetime && datetime.localtime.strftime("%Y-%m-%dT%H:%M:%SZ") # 2003-12-13T18:30:02Z
  end

  def hostname
    request.env["HTTP_HOST"]
  end

  def base_url
    "http://#{hostname}"
  end

  def markup(text)
    RDiscount.new(text).to_html
  end

  def partial(template, options = {})
    options = options.merge!({:layout => false})
    haml template.to_sym, options
  end

  def logged_in?
    session['potage_admin']# && session['potage_admin'] == Admin.session_key
  end

  def authorized?
    redirect '/auth' and return unless logged_in?
  end

  def authenticate(username, password)
    if username == Admin.username && password == Admin.password
      session['potage_admin'] = Admin.session_key
    else
      halt 401, 'Not Autorized'
    end
  end
end

before do
end

# 
# Routes
# 
get '/' do
  @post = Post.reverse_order(:updated_at).first
  @posts = Post.reverse_order(:updated_at)
  haml :index
end

get '/posts' do
  @posts = Post.reverse_order(:updated_at)
  haml :posts
end

get '/post/:id' do
  post = Post[params[:id]]
  raise Sinatra::NotFound unless post
  haml :post, :locals => {:post => post}
end

get '/auth' do
  haml :auth
end

post '/auth' do
  authenticate params[:username], params[:password]
  redirect '/'
end

get '/logout' do
  session['potage_admin'] = nil
  redirect '/'
end

get '/admin/posts/new' do
  authorized?
  post = Post.new
  haml :'admin/edit', :locals => {:post => post}
end

post '/admin/posts' do
  authorized?
  post = Post.new :title => params[:title], :content => params[:content]
  begin
    post.save
    redirect "/post/#{post.id}"
  rescue Sequel::ValidationFailed => e
    haml :'admin/edit', :locals => {:post => post}
  end
end

get '/feed' do
  @posts = Post.reverse_order(:created_at).limit(20)
  content_type 'application/xml', :charset => 'utf-8'
  builder :feed
end
