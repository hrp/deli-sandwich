#!/usr/bin/ruby

%w'rubygems sinatra sandwich haml'.each {|r| require r}

# Group delicious bookmarks by date

get '/:user' do
  params[:user] ||= 'madh'
  @user = params[:user]
  reuben = Sandwich.new(params[:user])
  @p = reuben.make_sandwich
  @p.each do |d|
    d[:title_date] = d[:date].strftime('%B %d, %Y').gsub(/\s0/, ' ')
  end
  haml :rss
end

get '/' do
  "Welcome to the deli. We're currently serving delicious links each day to tumblr."
end
