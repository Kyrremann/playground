-- Libraries
Class = require "class"
require "AnAL"

-- classes
-- Note: abstract classes should be required inside their respective class file
require "map"
require "tile"
require "player"
require "inventory"
require "item"
require "textbox"
require "soundhandler"
require "viewport"

-- other files
require "utils"
require "constants"
require "input"
require "commands"

-- game modes
require "menu"
require "game"

gr = love.graphics
ke = love.keyboard
-- mo = love.mouse
ti = love.timer
im = love.image
ev = love.event
au = love.audio
fs = love.filesystem
