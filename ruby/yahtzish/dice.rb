require_relative 'die'

class Dice
  def initialize(pool_size = 5)
    @dice = Array.new(pool_size) { Die.new }
    @saved = []
  end

  def roll
    @dice.map(&:roll)
  end

  def look_saved
    @saved.map(&:look)
  end

  attr_reader :saved

  def saved_value
    @saved[0].look
  end

  def saved_value_as_key(value = nil)
    value ||= saved_value
    case value
    when 1
      :ones
    when 2
      :twos
    when 3
      :threes
    when 4
      :fours
    when 5
      :fives
    when 6
      :sixes
    end
  end

  def saved_count
    @saved.count
  end

  def most_of
    freq = to_a.each_with_object(Hash.new(0)) { |v, h| h[v] += 1; }
    # freq.max_by { |_, v| v }
  end

  def save(value)
    (@saved << @dice.select { |die| die.look == value }).flatten!
    @dice.delete_if { |die| die.look == value }
  end

  def has(value)
    @dice.find { |die| die.look == value }
  end

  def reset
    @dice.append(@saved).flatten!
    roll
    @saved = []
  end

  def to_a
    @dice.map(&:to_i)
  end
end
