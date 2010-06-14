#!/usr/bin/ruby

%w'rubygems  sandwich ap'.each {|r| require r}

# Group delicious bookmarks by date

# get '/:name' do
#   reuben = Sandwich.new(params[:name].to_s)
#   ap reuben.make_sandwich
# end



require 'ap'
r = Sandwich.new('madh')
ap r.make_sandwich
