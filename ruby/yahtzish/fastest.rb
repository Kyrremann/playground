times = ARGV.first || 100_000

@die = Random.new
sum = 0
(1..times).each do |_n|
  score = Array.new(6)
  (1..6).each do |_r|
    # first roll
    pool = Array.new(6).map { |_d| @die.rand(6) + 1 }.sort.group_by(&:itself).values.sort_by(&:size)
    kv = nil
    (pool.size - 1).downto(0) do |i|
      if !pool[i].empty? && score[pool[i].first - 1].nil?
        kv = i
        break
      end
    end
    keep = kv.nil? ? [] : pool.delete_at(kv)
    keep = keep.flatten
    # second roll
    pool = pool.map { |_d| @die.rand(pool.size) + 1 }
    more_keep, pool = pool.partition { |d| d == keep.first }
    keep.append(more_keep).flatten!
    # third roll
    pool = pool.map { |_d| @die.rand(pool.size) + 1 }
    more_keep, pool = pool.partition { |d| d == keep.first }
    keep.append(more_keep).flatten!
    score[keep.first - 1] = keep.sum unless keep.empty?
  end
  sum += score.compact.sum
end

p sum / times
