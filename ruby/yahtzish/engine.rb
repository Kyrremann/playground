require_relative 'dice'

class Engine
  def initialize(verbose: false, categories: 6, rerolls: 3)
    @verbose = verbose
    @categories = categories
    @rerolls = rerolls
    @results = { ones: nil,
                 twos: nil,
                 threes: nil,
                 fours: nil,
                 fives: nil,
                 sixes: nil }
  end

  def reset
    @results = { ones: nil,
                 twos: nil,
                 threes: nil,
                 fours: nil,
                 fives: nil,
                 sixes: nil }
  end

  def start(dice)
    @categories.times do |roll|
      (1..@rerolls).each do |reroll|
        dice.roll

        puts "Roll ##{roll + 1}.#{reroll}" if @verbose
        puts "We got: #{dice}" if @verbose
        puts "Dice saved: #{dice.look_saved}" if @verbose
        save_value = think(dice, reroll)
        puts "Saving dice showing: #{save_value}" if save_value && @verbose
      end
      add_result(dice)
      puts '' if @verbose
      dice.reset
    end

    puts "Results: #{score}" if @verbose
    puts @results if @verbose
  end

  attr_reader :results

  def score
    @results.sum { |_key, die| die.nil? ? 0 : die[:points] }
  end

  private

  def think(dice, _reroll)
    return nil if no_usable_dice(dice)

    if dice.saved.empty?
      most_of = dice.most_of.sort_by(&:last).sort_by { |k, v| k * v }.reverse
      index = 0
      value = most_of[index][0]
      until available(value)
        index += 1
        value = most_of[index][0]
      end
      dice.save(value)
    else
      value = dice.saved_value
      if dice.has(value)
        dice.save(value)
      else
        value = nil
      end
    end

    value
  end

  def no_usable_dice(dice)
    (available_results & dice.to_a).empty?
  end

  def available(value)
    keys = @results.select { |_k, v| v.nil? }.keys
    keys.include?(value_as_key(value))
  end

  def add_result(dice)
    return if dice.saved.empty?
    key = dice.saved_value_as_key
    points = dice.saved_value * dice.saved_count
    @results[key] = {}
    @results[key][:points] = points
    @results[key][:dice] = dice.look_saved
  end

  def available_results
    @results.select { |_k, v| v.nil? }.keys.map { |k| key_as_value(k) }
  end

  def key_as_value(key)
    case key
    when :ones
      1
    when :twos
      2
    when :threes
      3
    when :fours
      4
    when :fives
      5
    when :sixes
      6
    end
  end

  def value_as_key(value)
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
end
