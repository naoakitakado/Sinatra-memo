# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'

PATH = './memos.json'

def memos
  File.open(PATH) { |file| JSON.parse(file.read) }
end

def keep_memos(memos)
  File.open(PATH, 'w') { |file| JSON.dump(memos, file) }
end

get '/' do
  @memos = memos
  erb :top
end

get '/memo/new' do
  erb :new
end

get '/memo/:id' do
  @memo = memos[params[:id]]
  erb :show
end

post '/memo' do
  title = params[:title]
  content = params[:content]

  memos = memos()
  id = if memos.to_s == '{}'
         '1'
       else
         (memos.keys.map(&:to_i).max + 1).to_s
       end
  memos[id] = { 'title' => title, 'content' => content }
  keep_memos(memos)

  redirect '/'
end

get '/memo/:id/edit' do
  @memo = memos[params[:id]]
  erb :edit
end

patch '/memo/:id' do
  title = params[:title]
  content = params[:content]

  memos = memos()
  memos[params[:id]] = { 'title' => title, 'content' => content }
  keep_memos(memos)

  redirect "/memo/#{params[:id]}"
end

delete '/memo/:id' do
  memos = memos()
  memos.delete(params[:id])
  keep_memos(memos)

  redirect '/'
end
