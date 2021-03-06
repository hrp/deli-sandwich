#!/usr/bin/ruby
$KCODE = 'u' if RUBY_VERSION < '1.9'

%w'rubygems sinatra sandwich haml'.each {|r| require r}

# Group delicious bookmarks by date

before do
  content_type :xml, 'charset' => 'utf-8'
end

get '/:user' do
  params[:user] ||= 'madh'
  @user = params[:user]
  reuben = Sandwich.new(params[:user])
  @p = reuben.make_sandwich
  @p.each do |d|
    d[:title_date] = d[:date].strftime('%B %d, %Y').gsub(/\s0/, ' ')
    d[:desc] = '<ul>'
    d[:bookmarks].each do |bm|
      d[:desc] << %[<li><a href='#{bm[:url]}'>#{bm[:title]}</a></li>]
    end
    d[:desc] << '</ul>'
    d[:desc] = h d[:desc]
  end
  haml :rss
end

get '/' do
  # "Welcome to the deli. We're currently serving delicious links each day to tumblr."
  haml :index
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
