#! /bin/ruby

require 'sinatra'
require 'haml'

require_relative 'stats'

get '/' do
  haml :index
end

get '/stats/:username/?' do
  items = get_items
  haml :stats, :locals => {
         :beers => items.count,
         :unique_beers => distinct(items).count,
         :last_week => last_days(items, get_wday).count,
         :beers_per_yr_day => beers_per_day(items, yr=true),
         :beers_per_day => beers_per_day(items)
       }
end

def get_wday
  day = Time.now.wday
  case day
  when 0
    return 7
  else
    return day
  end
end
