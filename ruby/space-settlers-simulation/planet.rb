class Planet
  attr_reader :humans, :food, :kyranium, :name, :farmers, :miners, :dead,
              :mod_humans, :mod_food, :mod_kyranium

  def initialize(humans, farmers, miners, mod_humans, mod_food, mod_kyranium,
                 name = 'some name')
    @humans = humans
    @farmers = farmers
    @miners = miners

    @mod_humans = mod_humans
    @mod_food = mod_food
    @mod_kyranium = mod_kyranium

    @name = name

    @food = 0
    @kyranium = 0
    @dead = 0
  end

  def add_workers(work, workers)
    return unless free_workers >= workers
    workers = workers > 0 ? workers : 0
    if work == 'FARMER'
      @farmers += workers
    elsif work == 'MINER'
      @miners += workers
    end
  end

  def remove_workers(work, workers)
    workers = workers > 0 ? workers : 0
    if work == 'FARMER'
      @farmers -= workers
    elsif work == 'MINER'
      @miners -= workers
    end
  end

  def free_workers
    (@humans - @farmers - @miners).to_i
  end

  def new_round
    # mine kyranium
    @kyranium += (@miners * @mod_kyranium).floor
    # gather food
    @food += (@farmers * @mod_food).floor
    # breed
    new_borns = (@humans * @mod_humans).floor # add later, they don't eat
    # kill people based on food
    food_for_humans = @food * 2.0
    if @humans > food_for_humans
      diff = @humans - food_for_humans
      @dead += diff
      @humans -= diff
      @food = 0
    else
      diff = food_for_humans - @humans
      rest = (diff / 2.0).ceil
      @food = rest
    end
    @humans += new_borns
  end

  def to_s
    {
      humans:   "#{@humans.to_i} (#{free_workers}/#{@dead.to_i})",
      food:     "#{@food} (#{@farmers})",
      kyranium: "#{@kyranium} (#{@miners})"
    }
  end
end
