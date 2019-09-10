# coding: utf-8

require 'squib'
require 'game_icons'

deck = Squib.csv file: 'hendelseskort.csv'

Squib::Deck.new(cards: deck['Tittel'].size, layout: ['layout.yml']) do
  cut_zone stroke_color: :black, maring: '0.05in'

  text str: deck['Tittel'], layout: :title

  svg file: GameIcons.get('cubes').file, layout: :art

  text str: deck['Hendelse'], layout: :description

  text str: deck['Kryddertekst'], layout: :flavour

  save_png prefix: 'mortulo_'
  save_pdf trim: 37.5
end
