@times = (ARGV.first || 100_000).to_i
@die = Random.new
@sum = 0
@number_of_die = 5

(1..@times).each do |_n|
  score = Array.new(6)
  (1..6).each do |_r|
    # first roll
    pool = Array.new(@number_of_die).map { |_d| @die.rand(6) + 1 }.sort.group_by(&:itself).values.sort_by(&:size)

    #p "First roll: #{pool}"
    kv = nil
    (pool.size - 1).downto(0) do |i|
      if score[pool[i].first - 1].nil?
        kv = i
        break
      end
    end
    keep = kv.nil? ? [] : pool.delete_at(kv)
    keep = keep.flatten
    #p "Keeping: #{keep}"
    # second roll
    pool = pool.flatten
    pool = pool.map { |_d| @die.rand(pool.size) + 1 }.sort.group_by(&:itself).values.sort_by(&:size)
    #p "Second roll: #{pool}"
    if keep.empty?
      kv = nil
      (pool.size - 1).downto(0) do |i|
        p pool
        if score[pool[i].first - 1].nil?
          kv = i
          break
        end
      end
      keep = kv.nil? ? [] : pool.delete_at(kv)
    else
      more_keep, pool = pool.partition { |d| d == keep.first }
      #p "Keeping: #{more_keep}"
      keep.append(more_keep).flatten!
    end

    # third roll
    pool = pool.map { |_d| @die.rand(pool.size) + 1 }.sort.group_by(&:itself).values.sort_by(&:size)
    #p "Third roll: #{pool}"
    if keep.empty?
      kv = nil
      (pool.size - 1).downto(0) do |i|
        p pool
        if score[pool[i].first - 1].nil?
          kv = i
          break
        end
      end
      keep = kv.nil? ? [] : pool.delete_at(kv)
    else
      more_keep, pool = pool.partition { |d| d == keep.first }
      #p "Keeping: #{more_keep}"
      keep.append(more_keep).flatten!
    end

    score[keep.first - 1] = keep.sum unless keep.empty?
    #p "Saving #{keep}"
    #p "Score is now #{score}"
  end
  @sum += score.compact.sum
end

p "Avg score: #{@sum / @times}"
