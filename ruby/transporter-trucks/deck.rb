require 'game_icons'
require 'squib'

spruce = 'a4_poker_card_8up.yml'

resources = Squib.csv(file: 'resources.csv')

Squib::Deck.new(cards: resources['food'].size, layout: 'layout.yaml') do
  background(color: '#fff')
  deck = resources

  svg(data: GameIcons.get('delapouite/modern-city').recolor(fg: '000', bg_opacity: 0).string, layout: :LargeCityIcon)
  text(str: deck['food'], layout: :LargeCityText)

  svg(data: GameIcons.get('delapouite/village').recolor(fg: '000', bg_opacity: 0).string, layout: :MediumCityIcon)
  text(str: deck['boxes'], layout: :MediumCityText)

  svg(data: GameIcons.get('delapouite/family-house').recolor(fg: '000', bg_opacity: 0).string, layout: :SmallCityIcon)
  text(str: deck['mail'], layout: :SmallCityText)

  save_png(prefix: 'resources_')
  save_pdf(file: 'resources.pdf', sprue: spruce)
end

missions = Squib.csv(file: 'missions.csv')

Squib::Deck.new(cards: missions['food'].size, layout: 'layout.yaml') do
  background(color: '#fff')
  deck = missions

  text(str: deck['city'], layout: :Title)
  text(str: deck['score'], layout: :Score)

  svg(data: GameIcons.get('delapouite/full-pizza').recolor(fg: '000', bg_opacity: 0).string, layout: :LargeCityIcon)
  text(str: deck['food'], layout: :LargeCityText)

  svg(data: GameIcons.get('delapouite/cardboard-box-closed').recolor(fg: '000', bg_opacity: 0).string, layout: :MediumCityIcon)
  text(str: deck['boxes'], layout: :MediumCityText)

  svg(data: GameIcons.get('delapouite/love-letter').recolor(fg: '000', bg_opacity: 0).string, layout: :SmallCityIcon)
  text(str: deck['mail'], layout: :SmallCityText)

  save_png(prefix: 'missions_')
  save_pdf(file: 'missons.pdf', sprue: spruce)
end
