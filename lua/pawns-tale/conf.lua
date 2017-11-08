function love.conf(t)
   t.title = "A Pawns Tale"
   t.author = "Kyrre Havik Eriksen"
   t.url = nil
   t.identity = nil 
   t.version = "0.10.2"
   t.release = false

   t.console = true
   
   -- t.window = false
   -- t.window.width = 1920
   -- t.window.height = 1080
   t.window.width = 800
   t.window.height = 600
   t.window.fullscreen = false
   t.window.vsync = true
   t.window.fsaa = 0

   t.modules.keyboard = true
   t.modules.event = true
   t.modules.image = true
   t.modules.graphics = true
   t.modules.timer = true

   t.modules.joystick = false
   t.modules.audio = true
   t.modules.mouse = true
   t.modules.sound = true
   t.modules.physics = false
end
