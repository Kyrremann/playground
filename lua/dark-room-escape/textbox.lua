--[[
   Text box class = a rectangle of text lines
   the text size scales according to the line_count and bounding 'rect' size
   
   Think of this class as a rectangle (first 4 arguments)
   + an amount of lines that can be displayed inside it! (last argument)

   adding a line, will remove the last line! (newest line drawn at bottom)
   (e.g for making a log, keep a separate table of the log history!
   this structure is only to display it easier!)
]]
-- superclass requires
require "visible"
TextBox = Class{ __includes = Visible }

function TextBox:init(x, y, width, height, line_count)
   Visible.init(self)
   self.visible = true
   self.x = x
   self.y = y
   self.w = width
   self.h = height
   self.line_count = line_count
   self.lines = {} -- content to display!
   
   self.line_height = self.h / self.line_count
   self.font = gr.newFont(math.floor(self.line_height))
end

function TextBox:update(dt)
   
end

function TextBox:draw()
   gr.setColor(255,255,255)
   gr.setFont(self.font)
   for i=1, #self.lines do
      local line_x = self.x
      local line_y = self.y + ((i-1)*self.line_height)
      gr.print(self.lines[i], line_x, line_y)
   end
end

function TextBox:add_line(line)
   if #self.lines == self.line_count then
      table.remove(self.lines, 1)
   end
   table.insert(self.lines, line)
end