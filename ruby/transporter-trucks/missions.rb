cities = [
  "Fosshøne",
  "Ora",
  "Neiheim",
  "Dagnes",
  "Storestrøm",
  "Solo",
  "Steinvika",
  "Ilder",
  "Brammen",
  "Kroksund",
  "Dronningsberg",
  "Staver",
  "Bskim",
  "Mosen",
  "Råkkestad",
  "Muss",
  "Brødbak",
  "Morten",
  "Erikstad",
  "Rolvsdal",
  "Bergstrand",
  "Tønsfjell",
]

file = File.open("./missions.csv", "w")
file.write("city, food, boxes, mail, score\n")

(0...22).each do |city|
  3.times.each do |t|
    set = [0, 0, 0]
    (0..2).to_a.shuffle.each do |i|
      break if set.sum > 15
      rnd = i == 0 ? 12 : i == 1 ? 9 : 6
      set[i] = Random.rand(rnd)
    end

    while set.size < 3
      set << 0
    end

    score = set[0]*10 + set[1]*20 + set[2]*30

    file.write("#{cities[city]}, #{set.join(', ')}, $#{score}\n")
  end
end

file.close
