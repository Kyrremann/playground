times = ARGV[0] || 100000

@die = Random.new
sum = 0
start = Time.now
(1..times).each do |n|
  score = Array.new(6)
  (1..6).each do |r|
    # first roll
    pool = Array.new(6).map{|d| @die.rand(6) +1}.sort.group_by(&:itself).values.sort{|a,b|a.size <=> b.size}
    kv = nil
    (pool.size - 1).downto(0) do |i|
      if not pool[i].empty? and score[pool[i].first - 1].nil?
        kv = i
        break
      end
    end
    keep = kv.nil? ? [] : pool.delete_at(kv)
    keep = keep.flatten
    # second roll
    pool = pool.map{|d| @die.rand(pool.size) +1}
    more_keep, pool = pool.partition{|d| d == keep.first}
    keep.append(more_keep).flatten!
    # third roll
    pool = pool.map{|d| @die.rand(pool.size) +1}
    more_keep, pool = pool.partition{|d| d == keep.first}
    keep.append(more_keep).flatten!
    score[keep.first - 1] = keep.sum unless keep.empty?
  end
  sum += score.compact.sum
end

p Time.now - start

p sum / times
