def generate()
  file = File.open("map_1.lua", 'w')
  file.write("return { [[\n")
  (0...24).each do | index |
    output = ""
    if index > 9 and index < 15 then
      (0...32).each do 
        output = output + "w"
      end
    else
      (0...32).each do 
        output = output + "g"
      end
    end
    output.concat("\n")
    file.write(output)
  end
  file.write("]] }")
end

generate
