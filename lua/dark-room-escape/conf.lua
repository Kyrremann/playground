function love.conf(t)
   t.title = "Escape"
   t.author = "Julian Hisdal Nymark and Kyrre Havik Eriksen"
   t.url = nil
   t.identity = nil 
   t.version = "0.9.0"
   t.release = false

   t.console = true
   
   -- t.screen = false
   -- t.screen.width = 1920
   -- t.screen.height = 1080
   t.window.width = 0
   t.window.height = 0
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
   t.modules.mouse = false
   t.modules.sound = true
   t.modules.physics = false
end
