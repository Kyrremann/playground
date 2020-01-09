local Score = {}

function Score:setup(font, x, y)
   self.points = 0
   self.x = x
   self.y = y
   self.font = font
end

function Score:draw()
   love.graphics.setFont(self.font)
   love.graphics.print(self.points, self.x, self.y)
end

function Score:awardPoints(points)
   self.points = self.points + points
end

return Score
