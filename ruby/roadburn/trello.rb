require 'trello'
require 'yaml'

line_up = YAML.load_file('lineup2018.yaml')


Trello.configure do |config|
  config.developer_public_key = ""
  config.member_token = ""
end

kyrre = Trello::Member.find("kyrrehavikeriksen")

roadburn_board = nil
kyrre.boards.each do |board|
  if board.name == "Roadburn 2018"
    roadburn_board = board
  end
end

board_item = nil
roadburn_board.lists.each do |item|
  if item.name == "Line-up"
    board_item = item
  end
end

line_up.each do |artist|
  puts "Adding #{artist}"
  options = {
    :name => "#{artist}",
    :list_id => board_item.id,
    :pos => "bottom"
  }
  Trello::Card.create(options)
end
