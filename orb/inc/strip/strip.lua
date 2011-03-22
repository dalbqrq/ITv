
require "util"


local s = text_file_reader("./s2")
--[[
print(s)
print("----------------------------------------------\n\n")
print("label", "type", "size", "value")
]]

--for l, t, z, v in string.gfind(s, "glpi([_%w]+)|(%a):(%d+):(.+)") do
while true do

   i, j, l, t, v = string.find(s, "glpi([_%w]+)|(%a):(.+)")
   --print(l, t, v)
   if t == "N" then
      print(l," = NULL")
      i, j, v, s = string.find(v,";(.+)")
   elseif t == "s" then
      i, j, z, v, s = string.find(v,"(%d+):\"([%w%W%(%)%s]*)\";(.+)")
      --print(l," = ", "'"..v.."'", s)
      print(l," = ", "'"..v.."'")
   elseif t == "i" then
      i, j, v, s = string.find(v,"(%d*);(.+)")
      --print(l," = ", v, s)
      print(l," = ", v)
   elseif t == "b" then
      i, j, v, s = string.find(v,"(%d);(.+)")
      --print(l," = ", v, s)
      print(l," = ", v)
   else
      break
   end

   if not s then break end

end

