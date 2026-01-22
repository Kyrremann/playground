--[[
   handles sounds.
]]
SoundHandler = Class{}

function SoundHandler:init()
   self.table = {}
end

function SoundHandler:play(sound_name)
   if self.table[sound_name] then
      self.table[sound_name]:stop()
      self.table[sound_name]:play()
   end
end

function SoundHandler:stop(sound_name)
   if self.table[sound_name] then
      self.table[sound_name]:stop()
   end
end

function SoundHandler:load(sound_name, filename)
   -- sound is buggy? try .ogg files or sumth maybe
   -- self.table[sound_name] = au.newSource(filename)
end

function SoundHandler:load_static(sound_name, filename)
   -- sound is buggy? try .ogg files or sumth maybe
   --self.table[sound_name] = au.newSource(filename, "static")
end