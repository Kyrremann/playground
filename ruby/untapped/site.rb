#! /bin/ruby

require 'date'
require 'influxdb'
require 'json'

file = File.read('untapped-11-01-2018.json')
data_hash = JSON.parse(file)

influxdb = InfluxDB::Client.new('untappd')#, 'root', 'root')
name = 'check_ins'

avg_abv = 0
avg_rating = 0
count_abv = 0
count_rating = 0
beers = []

data_hash.each do | check_in |
  beer_name = check_in['beer_name']
  beer_type = check_in['beer_type']
  beer_abv  = check_in['beer_abv'].to_i
  beer_ibu  = check_in['beer_ibu']
  brewery_name = check_in['brewery_name']
  brewery_country = check_in['brewery_country']
  created_at = check_in['created_at']
  rating_score = check_in['rating_score'].to_i
  year = DateTime.parse(created_at).year

  if year == 2017
    unless beers.include?(beer_name)
      avg_abv = avg_abv + beer_abv
      if beer_abv != 0
        count_abv = count_abv + 1.0
      end

      avg_rating = avg_rating + rating_score
      if rating_score != 0
        count_rating = count_rating + 1.0
      end

      beers << beer_name
    end
  end    
end

count = beers.length
p count
p avg_abv / count_abv
p avg_rating / count_rating
