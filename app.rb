# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

get '/' do
  path = './views/memo/'
  @memolist = []
  @titles = []

  Dir.foreach(path.to_s) do |item|
    case item
    when '.', '..'
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
    when '.', '..'
      nil
    else
      @memolist << item
    end
  end

  @memolist.each do |item|
    File.open("#{path}#{item}", 'r') { |f| @titles << f.gets.chomp }
  end
  erb :top
end

get '/memo/*' do
  path = './views/memo/'
  @memolist = []
  @filename = params['splat']

  @memo = []
  File.foreach("#{path}#{@filename[0]}") { |f| @memo << f.chomp }
  @title =  @memo[0]
  @contents = @memo[1..]
  erb :show
end

post '/memo/*' do
  path = './views/memo/'
  @memolist = []
  @titles = []
  @editfile = params['splat']
  @memo = []

  File.foreach("#{path}#{@editfile[0]}") { |f| @memo << f.chomp }
  @title =  @memo[0]
  @contents = @memo[1..]
  @test = @contents.join('&#13;&#10;')
  erb :edit
end

patch '/memo/*' do
  path = './views/memo/'
  @editfile = params['splat']
  @title = params[:title]
  @contents = params[:content]

  file = File.new("#{path}#{@editfile[0]}", 'w')
  file.puts @title.to_s
  file.puts @contents.to_s
  file.close

  @memolist = []
  @titles = []

  Dir.foreach(path.to_s) do |item|
    case item
    when '.', '..'
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

delete '/memo/*' do
  path = './views/memo/'
  @memolist = []
  @titles = []

  deletefile = params['splat']
  File.delete("#{path}#{deletefile[0]}")

  Dir.foreach(path.to_s) do |item|
    case item
    when '.', '..'
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
