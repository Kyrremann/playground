function portrait_draw(piece)
   local offsetX = boardTileX * 9.5
   local offsetY = boardTileY * 1
   
   gr.setColor(238, 238, 238)
   gr.rectangle("fill", 
	   offsetX, offsetY, 
	   boardTileX * 2.5, boardTileY * 3.5)
   gr.setColor(0,0,0)
   offsetY = offsetY + 5
   gr.print("Name: " .. piece.type, 
	   offsetX + 5, offsetY)
   gr.print("Value: " .. piece.value, 
	    offsetX + 5, offsetY + defaultFontSize * 1.5)
   gr.print("Team: " .. piece.color, 
	   offsetX + 5, offsetY + defaultFontSize * 3)
end
