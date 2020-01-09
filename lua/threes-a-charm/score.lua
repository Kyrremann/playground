local score = {}

function score.setup(font, x, y)
   score.points = 0
   score.x = x
   score.y = y
   score.font = font
end

function score.draw()
   love.graphics.setFont(score.font)
   love.graphics.print(score.points, score.x, score.y)
end

function score.awardPoints(points)
   score.points = score.points + points
end

return score
