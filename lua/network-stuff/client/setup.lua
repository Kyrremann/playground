gra = love.graphics
img = love.image
key = love.keyboard
tim = love.timer
eve = love.event
win = love.window
mou = love.mouse

-- setup of asset directories
assetsDir = "assets"
animationDir = assetsDir.."/animations"
soundsDir = assetsDir.."/sounds"
musicDir = assetsDir.."/music"

math.randomseed( os.time() )
win.setMode(1000, 700, {})
