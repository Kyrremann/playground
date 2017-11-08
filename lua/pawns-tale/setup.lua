gr = love.graphics
ke = love.keyboard
mo = love.mouse

Class = require "class"

require "piece"
require "engine"
require "portrait"

caseFont = gr.newFont('fonts/casefont.ttf')
chessTileset = gr.newImage('images/TileSet.png')
boardTileset = gr.newImage('images/chessgrille.png')
tileQuads = {}
boardQuads = {}
tileSizeX = 48
tileSizeY = 40
boardTileX = 63
boardTileY = 63
active_drag = false
defaultFontSize = 12
