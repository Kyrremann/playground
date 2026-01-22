function love.load()   
   love.window.setMode(800, 600, { fullscreen=true, fullscreentype="normal", vsync=true } )
   require "setup"

   love.keyboard.setKeyRepeat( enable )
   
   game_modes = { menu = menu, game = game, credit = credit }
   game_mode = "menu"
   init = true
   
   -- create player
   player = Player(2, 2)
   -- create map & load tile images
   map = Map()
   map.tile_images[0] = gr.newImage( "tiles/void.png" )
   map.tile_images[1] = gr.newImage( "tiles/grass_1.png" )
   map.tile_images[2] = gr.newImage( "tiles/rock_1.png" )
   map.tile_images[3] = gr.newImage( "tiles/lava_1.png" )
   
   -- create viewport (camera)
   local vp_x = player.grid_x - (math.floor(VIEWPORT_SIZE_X/2))
   local vp_y = player.grid_x - (math.floor(VIEWPORT_SIZE_X/2))
   viewport = Viewport(vp_x,
		       vp_y,
		       VIEWPORT_SIZE_X,
		       VIEWPORT_SIZE_Y)

   -- soundhandler & load all sounds
   sounds = SoundHandler()
   sounds:load_static("drop", "sound/drop.wav")
   sounds:load_static("goal", "sound/goal.wav")
   sounds:load_static("grab", "sound/grab.wav")
   sounds:load_static("jump", "sound/jump.wav")
   sounds:load_static("negative", "sound/negative.wav")
   sounds:load_static("nope", "sound/nope.wav")
   sounds:load_static("suicide", "sound/suicide.wav")

   -- same for music
   music = SoundHandler()
   music:load("music1", "music/music1.wav")
end

function love.update(dt)
   if init and game_modes[game_mode].init then
      game_modes[game_mode].init()
   end
   if game_modes[game_mode].update then 
      game_modes[game_mode].update(dt)
   end
end

function love.draw()
   if not BLIND then
      if not init and game_modes[game_mode].draw then 
	 game_modes[game_mode].draw()
      end
   end
end

function love.keypressed(key, isrepeat)
   if game_modes[game_mode].keypressed then 
      game_modes[game_mode].keypressed(key, isrepeat)
   end
end
