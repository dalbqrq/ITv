
require "util"


local s = text_file_reader("./s4")

s = 'glpiprofiles|a:1:{i:4;a:2:{s:4:"name";s:11:"super-admin";s:8:"entities";a:1:{i:0;a:3:{s:2:"id";s:1:"0";s:4:"name";N;s:12:"is_recursive";s:1:"1";}}}}'

while true do

   _, _, l, t, v = string.find(s, "glpi([_%w]+)|(%a):(.+)")

   if t == "N" then
      print(l," = NULL")
      _, _, v, s = string.find(v,";(.+)")
   elseif t == "s" then
      _, _, _, v, s = string.find(v,"(%d+):\"([^;.*]*)\";(.+)")
      if not v then v = "" end
      print(l," = ", "'"..v.."'")
   elseif t == "a" then

-----------------------------------------------------

local i = 0
while true do
   i = i + 1

   _, _, _, w, r = string.find(v,"(%d+):({[^{^}.*]*})(.+)")
   if not w then 
      break
   else
      print("INNER: ",w)
      print("LIST: ",v)
      v = string.gsub(v,w,"X")
      print("LIST: ",v)
      print("REST: ",r)
   end

   if i > 4 then break end

   print(l," = ", "'"..v.."'")

end


-----------------------------------------------------


   elseif t == "i" then
      _, _, v, s = string.find(v,"(%d*);(.+)")
      print(l," = ", v)
   elseif t == "b" then
      _, _, v, s = string.find(v,"(%d);(.+)")
      print(l," = ", v)
   else
      break
   end

   if not s then break end

end

