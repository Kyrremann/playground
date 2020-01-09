lu = require('luaunit')
score = require('score')
score:setup(nil, 1)

function testAwardPoints()
   score:awardPoints(10)
   lu.assertEquals(score.points, 10)
end

lu.LuaUnit:run()
