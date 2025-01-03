def alt1
  set = []
  while set.sum < 10 do
    break if set.size >= 3

    set << Random.rand(10)
    
    if set.sum > 10
      #p 10 - set[0, set.size - 1].sum
      #set[-1] = set.sum - 11
      set[-1] = 10 - set[0, set.size - 1].sum
    end
  end

  set << 0 if set.size < 3
  set
end

def alt2
  set = [
    Random.rand(8),
    Random.rand(6),
    Random.rand(4)
  ]
end

22.times.each do |n|
  set = alt2

  #print set.sum, " "
  puts set.join('/')
end
