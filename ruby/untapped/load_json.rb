#! /bin/ruby

require 'json'

def load
  file = File.read('untapped-11-01-2018.json')
  return JSON.parse(file)
end
