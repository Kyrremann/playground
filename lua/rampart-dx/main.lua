function love.load()
   require "setup"

   gamestate = Gamestate:new()

   gametimer = Gametimer:new(gamestate)
   PLAYERS = {}
   CANNONS = {}
   BULLETS = {}

   SIZE = 32
   
   local fontUrl = "fonts/kenpixel_future_square.ttf"
   fontMini = gr.newFont(fontUrl, 11)
   fontSmall = gr.newFont(fontUrl, 22)
   fontBig = gr.newFont(fontUrl, 48)

   math.randomseed(os.time())

   map = load_map(require "maps.map_1")
end

function love.update(dt)
   gametimer:update(dt)
   for i, player in ipairs(PLAYERS) do
      player:update(dt)
   end
end

function love.draw()
   -- for now, always black
   drawBackground()

   if gamestate:isMenu() then
      drawTitle()
      for i, player in ipairs(PLAYERS) do
	 player:draw()
      end
      
   elseif gamestate:isGame() then
      draw_map()   
      if gamestate:isBuildWallsTurn() then
	 for i, player in ipairs(PLAYERS) do
	    drawWall(player)
	 end

      elseif gamestate:isPlaceCannonsTurn() then
	 for i, player in ipairs(PLAYERS) do
	    drawCannon(player)
	 end

      elseif gamestate:isFightTurn() then
	 for i, player in ipairs(PLAYERS) do
	    player:draw()
	 end
      end

   elseif gamestate:isEnd() then
   end

   gametimer:draw()
end

function love.keypressed(key, scancode, isrepeat)
   if gameMode == MENU then
      if key == "escape" then
	 love.event.push('quit')
	 return
      elseif key == "return" then
	 startGame()
	 return
      end

   elseif gameMode == GAME then
      if key == "escape" then
	 -- gameMode = END
	 love.event.push('quit')
	 return
      end

   elseif gameMode == END then
      if key == "escape" then
	 gameMode = MENU
      elseif key == 'return' then
	 gameMode = MENU
      end
   end
   
   if key == 'f9' then
      debug = not debug
      return
   end
end

function love.keyreleased(key, scancode)
   if gamestate:isMenu() then
      -- players are init'ed when 
      -- they hit the respectiv button
      if key == "space" then
	 table.insert(PLAYERS,
		      Player:new("p" .. #PLAYERS + 1,
				 { 0, 255, 255 }, 
				 "keyboard",
				 gamestate))
      end
      for i, player in ipairs(PLAYERS) do
	 if player:isUsingKeyboard() and
	 player:keyreleased(key) then
	    return
	 end
      end
   end
end

function love.mousepressed(x, y, button, istouch)
   for i, player in ipairs(PLAYERS) do
      if player:isUsingMouse() then
	 player:mousepressed(x, y, button)
      end
   end
end

function love.mousereleased(x, y, button, istouch)
   if button == 1 then
      if gamestate:isMenu() then
	 if isMouseFree() then
	    table.insert(PLAYERS, Player("p" .. #PLAYERS + 1, 
					 { 0, 0, 210 }, 
					 "mouse"))
	 end
      elseif gamestate:isGame() then
	 for i, player in ipairs(PLAYERS) do
	    if player:isUsingMouse() then
	       player:mousereleased(x, y, button)
	    end
	 end
      end
   end
end

function drawBackground()
end

function drawTitle()
   gr.setColor(255, 255, 255)
   gr.setFont(fontBig)
   gr.printf("Rampart Deluxe", 
	     0, gr.getHeight() / 10, gr.getWidth(), "center")
end

function isMouseFree()
   for i, v in ipairs(PLAYERS) do
      if v:isUsingMouse() then
	 return false
      end
   end
   return true
end
