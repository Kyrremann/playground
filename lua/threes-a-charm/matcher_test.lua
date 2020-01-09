lu = require('luaunit')
m = require('matcher')

TestRow = {}
function TestRow:setUp()
   self.level = {
      {1, 2, 3, 4},
      {1, 3, 2, 2},
      {1, 3, 3, 3},
      {4, 2, 2, 1}}
end

function TestRow:testCheckRow()
   matches = m:checkRow(self.level, 1, 1, 1)
   lu.assertEquals(matches, {{tile=1, x=1, y=1}})

   matches = m:checkRow(self.level, 3, 1, 1)
   lu.assertEquals(matches, {{tile=1, x=3, y=1}})

   matches = m:checkRow(self.level, 3, 2, 3)
   lu.assertEquals(matches, {{tile=3, x=3, y=2}, {tile=3, x=3, y=3}, {tile=3, x=3, y=4}})
end

TestColumn = {}
function TestColumn:setUp()
   self.level = {
      {1, 2, 3, 4},
      {1, 3, 2, 2},
      {1, 3, 2, 4},
      {4, 2, 2, 1}}
end

function TestColumn:testCheckColumn()
   matches = m:checkColumn(self.level, 1, 1, 1)
   lu.assertEquals(matches, {{tile=1, x=1, y=1}, {tile=1, x=2, y=1}, {tile=1, x=3, y=1}})

   matches = m:checkColumn(self.level, 2, 1, 1)
   lu.assertEquals(matches, {{tile=1, x=2, y=1},{tile=1, x=3, y=1}})

   matches = m:checkColumn(self.level, 2, 3, 2)
   lu.assertEquals(matches, {{tile=2, x=2, y=3}, {tile=2, x=3, y=3}, {tile=2, x=4, y=3}})
end

lu.LuaUnit:run()
