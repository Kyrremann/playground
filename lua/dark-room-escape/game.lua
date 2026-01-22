game = {}

function game.init()
   init = false
   
   -- create TextBoxes
   -- 1 line command input TextBox
   local c_input_loc = gr.getHeight() - 25
   c_input_tb = TextBox(5,c_input_loc,0,20,1)
   -- 10 line command log TextBox
   local c_log_line_count = 10
   local c_log_height = c_log_line_count * 16
   local c_log_loc = c_input_loc - 10 - c_log_height
   c_log_tb = TextBox(5,c_log_loc,0,c_log_height,c_log_line_count)

end

-- main update loop
function game.update(dt)
   viewport:update(dt)
   player:update(dt)
end

-- main draw loop
function game.draw()
   --map:draw()
   viewport:draw()
   player.inventory:draw()
   
   -- draw textboxes & line separator
   -- todo put all in a "text area" container
   gr.setColor(255,255,255)
   gr.setLineWidth(2)
   gr.line(5, c_input_tb.y - 5, 50, c_input_tb.y - 5)
   c_input_tb:draw()
   c_log_tb:draw()
end

function game.keypressed(key, unicode)
   input_handler(key, unicode)
end
