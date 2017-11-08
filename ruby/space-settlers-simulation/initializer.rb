require 'json'

require_relative 'simulations'
require_relative 'space_settlers'
require_relative 'planet'

planet = Planet.new(10, 5, 5, 0.24, 1, 0.5, 'earth')

singel_planet_x_rounds(planet, 10)


