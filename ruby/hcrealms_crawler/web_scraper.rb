require 'rubygems'
require 'bundler/setup'

require 'httparty'
require 'nokogiri'
require 'json'

require_relative 'parse_char'

@UNIT_URL = 'http://www.hcrealms.com/forum/units/units_bbcode.php?id='
sets = {}
set = 'smww'

sets[set] = {}
def parse_set(set, range)
  (1..1).each do | id |
    id = "%03d" % id
    id = '041b'
    page = HTTParty.get(@UNIT_URL + set + id)
    parse_page = Nokogiri::HTML(page)

    table = parse_page.css('textarea')[1]
    char = {}
    table.text.split(/\n/).each do | n |
      if n.empty?
        next
      elsif n.start_with?(set + id)
        char[:name] = n.match(/\[b\](.+)\[\/b\]/)[1]
      elsif n.start_with?('Team: ')
        char[:team_ability] = n.match(/\[b\](.+)\[\/b\]/)[1]
      elsif n.start_with?('Range: ')
        char[:range] = parse_range(n.match(/\[b\](.+)\[\/b\]/)[1])
      elsif n.start_with?('Points: ')
        char[:points] = n.match(/\[b\](.+)\[\/b\]/)[1]
      elsif n.start_with?('Keywords: ')
        char[:keywords] = n.match(/\[b\](.+)\[\/b\]/)[1]
      elsif n.start_with?('[dial]')
        char[:dial] = parse_dial(n)
      elsif n.start_with?('[b](Special)')
        char[:specials] ||= []
        char[:specials] << parse_specials(n)
      else
        p 'Unknown value'
        char[:help] ||= []
        char[:help] << n
      end
    end
    sets[set][id] = char
  end
  sets
end
