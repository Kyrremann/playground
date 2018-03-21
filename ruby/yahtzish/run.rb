require_relative 'engine'

min = 10000
max = -1
sum = 0
times = 1000

p "Running #{times} times"

(0..times).each do |n|
  e = Engine.new
  dice = Dice.new
  e.start(dice)
  sum += e.score
  if e.score > max
    max = e.score
  end
  if e.score < min
    min = e.score
  end
end

p "Max points: #{max}"
p "Min points: #{min}"
p "Avg points: #{sum / times.to_f}"
