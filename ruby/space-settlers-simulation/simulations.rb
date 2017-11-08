def even_workload
  return Proc.new { | planet |
    planet.add_workers('FARMER', (planet.free_workers / 2.0).floor)
    planet.add_workers('MINER', planet.free_workers)
  }
end

def max_food
  return Proc.new { | planet |
    if planet.miners > 0
      planet.remove_workers('MINER', planet.miners)
    end

    if planet.free_workers > 0
      planet.add_workers('FARMER', planet.free_workers)
    end
  }
end

def max_kyranium
  return Proc.new { | planet |
    farmers_needed = (planet.humans / 2.0).ceil

    if farmers_needed > planet.farmers
      extra_farmers = farmers_needed - planet.farmers
      planet.add_workers('FARMER', extra_farmers)
      planet.add_workers('MINER', (planet.free_workers))
    else
      planet.add_workers('MINER', planet.free_workers)
    end
  }
end

def singel_planet_x_rounds(planet, rounds)
  work = max_kyranium#max_food#even_workload

  (0...rounds).each do | counter |
    puts "Round ##{counter + 1}"
    work.call(planet)
    puts planet.to_s
    planet.new_round
  end
end

