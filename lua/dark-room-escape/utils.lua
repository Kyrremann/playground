utils = {}

function utils.match(some_string, pattern)
   local result = {}
   for i in string.gmatch(some_string, pattern) do
      table.insert(result, i)
   end
   return result
end

function utils.close_enough(a, b, threshold)
   if a == b then return true end
   if math.abs(a - b) <= threshold then return true end
   return false
end
