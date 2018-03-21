class Die
  def initialize(sides: 6, value: nil)
    @die = Random.new
    @sides = sides
    roll unless value
    @value = value if value
  end

  def roll
    @value = @die.rand(@sides) + 1
  end

  def look
    @value
  end

  def to_i
    @value.to_i
  end
end
