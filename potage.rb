require 'rubygems'
require 'sinatra'
require 'sequel'

configure do
  DB = Sequel.connect('sqlite://db/potage.db')
  p DB
  DB.drop_table(:posts) if DB
  DB.create_table :posts do
    primary_key :id
    String    :title
    String    :body
    DateTime  :created_at
    DateTime  :updated_at
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/models')
require 'post'

get '/' do
  @posts = Post.all
end

get '/posts' do
  @posts = Post.reverse_order(:updated_at)
end

get '/post/:id' do
  post = Post[params[:id]]
end

post '/post' do
  post = Post.create(params[:post])
end
