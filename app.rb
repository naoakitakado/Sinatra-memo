# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'

PATH = './memos.json'

def get_memos(path)
  File.open(path) { |file| JSON.parse(file.read) }
end

def set_memos(path, memos)
  File.open(path, 'w') { |file| JSON.dump(memos, file) }
end

get '/public.html' do
  erb :top
end

get '/' do
  @memos = get_memos(PATH)
  erb :top
end

get '/memo' do
  erb :new
end

get '/memo/:id' do
  @memos = get_memos(PATH)
  erb :show
end

post '/memo' do
  title = params[:title]
  content = params[:content]

  memos = get_memos(PATH)
  id = if memos.to_s == '{}'
         '1'
       else
         (memos.keys.map(&:to_i).max + 1).to_s
       end
  memos[id] = { 'title' => title, 'content' => content }
  set_memos(PATH, memos)

  redirect '/'
end

get '/memo/:id/edit' do
  @memos = get_memos(PATH)
  erb :edit
end

patch '/memo/:id/edit' do
  title = params[:title]
  content = params[:content]

  memos = get_memos(PATH)
  memos[params[:id]] = { 'title' => title, 'content' => content }
  set_memos(PATH, memos)

  redirect "/memo/#{params[:id]}"
end

delete '/memo/:id' do
  memos = get_memos(PATH)
  memos.delete(params[:id])
  set_memos(PATH, memos)

  redirect '/'
end
