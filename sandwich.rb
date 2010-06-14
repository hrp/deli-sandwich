#!/usr/bin/ruby

%w'rubygems json open-uri'.each {|r| require r}

class Sandwich
  
  attr_reader :bookmarks, :url, :user
  
  BASE_URI = 'http://feeds.delicious.com/v2/json/'
  
  def initialize( delicious_user , time_zone = '-7' )
    @user = delicious_user
    @url  = make_url
    @bookmarks = get_bookmarks
  end
  
  def make_url
    BASE_URI + @user + '?count=25'
  end
  
  def get_bookmarks
    bookmarks = JSON.parse(open(@url).read)
    bookmarks.map { |a| a['tp'] = Time.parse(a['dt']).localtime }
    bookmarks.map { |a| a.delete('t') }
    mapping = {
      :user => 'a',
      :notes => 'n',
      :title => 'd',
      :url => 'u',
      :pub_date => 'dt',
      :pub_date_parsed => 'tp',
      :tags => 't'
    } 
    bookmarks.map! do |bm|
      h = {}
      mapping.each_pair do |k,v|
        h[k] = bm[v]
      end
      h
    end
    bookmarks
  end
  
  def group_bookmarks_by_day
    all_days, a_day = [], []
    hero = @bookmarks.first[:pub_date_parsed].local_mday
    @bookmarks.each do |bm|
      if hero == bm[:pub_date_parsed].local_mday
        a_day << bm
      else
        all_days << a_day unless a_day.empty?
        a_day = []
        hero = bm[:pub_date_parsed].local_mday
      end
    end
    all_days.compact
    all_days.map! do |day|
      h = {}
      h[:bookmarks] = day.dup
      h[:date] = day.first[:pub_date_parsed]
      h[:count] = h[:bookmarks].size
      h
    end
    all_days
  end
  
  def make_sandwich
    all_days = group_bookmarks_by_day
  end

end

class Time
  def same_day?( time )
    self.localtime.mday == time.localtime.mday
  end
  def local_mday
    self.localtime.mday
  end
end
