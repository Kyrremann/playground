gr = love.graphics
ke = love.keyboard
mo = love.mouse

ti = love.timer
im = love.image
ev = love.event
so = love.sound
au = love.audio

require "math"

require "map"
require "build"
require "fight"
require "engine"

Player = require "player"
Bullet = require "bullet"
Cannon = require "cannon"
Gamestate = require "gamestate"
Gametimer = require "gametimer"

SHAPES = require "shapes"

ke.setKeyRepeat(.01, .01)
mo.setVisible(false) 

debug = false
