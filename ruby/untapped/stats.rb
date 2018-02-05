#! /bin/ruby
# coding: utf-8

require 'sequel'

def get_items
  db = Sequel.connect('postgres://postgres:postgres@localhost:5432/postgres')
  db[:items]
end

def distinct(items)
  items.distinct(:beer_name)
end

def filter_by_year(items, year)
  items.where(Sequel.extract(:year, :created_at) => year)
end

def filter_by_brewery_country(items, country)
  items.where(:brewery_country => country)
end

def avg_abv(items)
  items.avg(:beer_abv)
end

def last_days(items, days)
  items.where(created_day: (Date.today - days)..(Date.today))
end

def beers_per_day(items, yr=false)
  if yr
    items.group_and_count(:created_yr_day).order(:created_yr_day)
  else
    items.group_and_count(:created_day).order(:created_day)
  end
end
