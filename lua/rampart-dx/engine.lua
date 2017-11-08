function startGame()
   gamestate:setMode(Gamestate.GAME)
   init_towers()
   gamestate:startBuildTurn()
end
