# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi/escape'
require 'dotenv/load'

PATH = './views/memo/'

get '/' do
  @memolist = []
  @titles = []

  Dir.foreach(PATH.to_s) do |item|
    case item
    when '.', '..', '.gitkeep'
      nil
    else
      @memolist << item
    end
  end
  @memolist.each do |filename|
    File.open("#{PATH}#{filename}", 'r') { |f| @titles << f.gets.chomp }
  end

  erb :top
end

get '/memo/new' do
  erb :new
end

post '/memo' do
  memolist = []
  @titles = []
  @title = params[:title]
  @content = params[:content]

  filename = ('A'..'Z').to_a.sample(11).join

  File.open("./views/memo/#{filename}.txt", 'w') do |file|
  file.puts @title.to_s
  file.puts @content.to_s
  end
  Dir.foreach(PATH.to_s) do |item|
    case item
    when '.', '..', '.gitkeep'
      nil
    else
      memolist << item
    end
  end

  memolist.each do |item|
    File.open("#{PATH}#{item}", 'r') { |f| @titles << f.gets.chomp }
  end

  redirect './'
end

get '/memo/:file' do
  @filename = CGI.escapeHTML(params['file'].to_s)

  memo = []
  File.foreach("#{PATH}#{CGI.unescapeHTML(@filename)}") { |f| memo << f.chomp }
  @title =  memo[0]
  @contents = memo[1..]
  erb :show
end

get '/memo/edit/:file' do
  memolist = []
  titles = []
  @editfile = CGI.escapeHTML(params['file'])
  @memo = []

  File.foreach("#{PATH}#{CGI.unescapeHTML(@editfile)}") { |f| @memo << f.chomp }
  @title =  @memo[0]
  contents = @memo[1..]
  @content = contents.join("\n")
  erb :edit
end

patch '/memo/edit/:file' do
  editfile = CGI.escapeHTML(params['file'])
  @title = CGI.escapeHTML(params[:title].to_s)
  contents = CGI.escapeHTML(params[:content].to_s)

  File.open("./views/memo/#{filename}.txt", 'w') do |file|
  file.puts @title.to_s
  file.puts @content.to_s
  end

  memolist = []
  @titles = []

  Dir.foreach(PATH.to_s) do |item|
    case item
    when '.', '..', '.gitkeep'
      nil
    else
      memolist << item
    end
  end
  memolist.each do |filename|
    File.open("#{PATH}#{filename}", 'r') { |f|  @titles << f.gets.chomp }
  end


  redirect './'
end

delete '/memo/:file' do
  @memolist = []
  @titles = []

  deletefile = CGI.escapeHTML(params['file'])
  File.delete("#{PATH}#{CGI.unescapeHTML(deletefile)}")

  Dir.foreach(PATH.to_s) do |item|
    case item
    when '.', '..'
      nil
    else
      @memolist << item
    end
  end

  redirect './'
end
