# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi/escape'

get '/' do
  path = './views/memo/'
  @memolist = []
  @titles = []

  Dir.foreach(path.to_s) do |item|
    case item
    when '.', '..', '.gitkeep'
      nil
    else
      @memolist << item
    end
  end
  @memolist.each do |filename|
    File.open("#{path}#{filename}", 'r') { |f| @titles << f.gets.chomp }
  end

  erb :top
end

get '/new' do
  erb :new
end

post '/strage' do
  path = './views/memo/'
  @memolist = []
  @titles = []
  @title = params[:title]
  @content = params[:content]

  filename = ('A'..'Z').to_a.sample(11).join
  file = File.new("./views/memo/#{filename}.txt", 'w')
  file.puts @title.to_s
  file.puts @content.to_s
  file.close
  Dir.foreach(path.to_s) do |item|
    case item
    when '.', '..', '.gitkeep'
      nil
    else
      @memolist << item
    end
  end

  @memolist.each do |item|
    File.open("#{path}#{item}", 'r') { |f| @titles << f.gets.chomp }
  end
  redirect 'http://localhost:4567/'
end

get '/memo/*' do
  path = './views/memo/'
  @memolist = []
  @filename = CGI.escapeHTML(params['splat'][0].to_s)

  @memo = []
  File.foreach("#{path}#{CGI.unescapeHTML(@filename)}") { |f| @memo << f.chomp }
  @title =  @memo[0]
  @contents = @memo[1..]
  erb :show
end

post '/memo/*' do
  path = './views/memo/'
  @memolist = []
  @titles = []
  @editfile = CGI.escapeHTML(params['splat'][0].to_s)
  @memo = []

  File.foreach("#{path}#{CGI.unescapeHTML(@editfile)}") { |f| @memo << f.chomp }
  @title =  @memo[0]
  @contents = @memo[1..]
  @test = @contents.join('&#13;&#10;')
  erb :edit
end

patch '/memo/*' do
  path = './views/memo/'
  @editfile = CGI.escapeHTML(params['splat'][0].to_s)
  @title = CGI.escapeHTML(params[:title][0].to_s)
  @contents = CGI.escapeHTML(params[:content].to_s)

  file = File.new("#{path}#{@editfile[0]}", 'w')
  file.puts @title.to_s
  file.puts @contents.to_s
  file.close

  @memolist = []
  @titles = []

  Dir.foreach(path.to_s) do |item|
    case item
    when '.', '..', '.gitkeep'
      nil
    else
      @memolist << item
    end
  end
  @memolist.each do |filename|
    File.open("#{path}#{filename}", 'r') { |f| @titles << f.gets.chomp }
  end

  redirect 'http://localhost:4567/'
end

delete '/memo/*' do
  path = './views/memo/'
  @memolist = []
  @titles = []

  deletefile = CGI.escapeHTML(params['splat'][0].to_s)
  File.delete("#{path}#{CGI.unescapeHTML(deletefile)}")

  Dir.foreach(path.to_s) do |item|
    case item
    when '.', '..'
      nil
    else
      @memolist << item
    end
  end

  redirect 'http://localhost:4567/'
end
