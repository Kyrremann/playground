@types = ['speed', 'attack', 'defense', 'damage']

def parse_clicks(text, header)
  clicks = text.split('[/click]').map {|c| c.sub('[click]', '').split('[/slot]')}
  clicks.each_with_index do | click, click_index |
    click.each_with_index.map { | slot, index |
      slot = slot.split(']')
      click[index] = {
        :color => slot[0].sub!('[slot=', ''),
        :value => slot[1],
        :type => @types[index],
        :symbol => header[index][:symbol],
        :click => click_index + 0
      }
    }
  end
  clicks
end

def parse_header(header)
  header.slice!('[header]')
  header.gsub!('[icon]', '')
  header = header.split('[/icon]')
  header.each_with_index.map { | slot, index |
    header[index] = {
      :symbol => slot.sub(/[madg]-/, ''),
      :type => @types[index]
    }
  }
  header
end

def parse_dial(text)
  text.slice!('[dial]')
  text.slice!('[/dial]')
  splitted = text.split('[/header]')
  header = parse_header(splitted[0])
  {
    :header => header,
    :clicks => parse_clicks(splitted[1], header)
  }
end

def parse_range(text)
  text = text.split(' ')
  {
    :distance => text[0],
    :targets => text[1].scan(':bolt:').count
  }
end

def parse_specials(text)
  text.slice!('[b]')
  splitted = text.split('[/b]')
  {
    :name => splitted[0],
    :ability => splitted[1]
  }
end
