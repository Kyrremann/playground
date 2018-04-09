require_relative 'engine'

sum = 0
times = ARGS.first || 100000

e = Engine.new
dice = Dice.new
(0..times).each do |n|
  e.start(dice)
  sum += e.score
  e.reset
end

p "Avg points: #{sum / times.to_f}"
