require "util"

local s = text_file_reader("./s4")

function string.strip(s,tab)
   local res = {}
   local cnt = 0
   local l, t, v, b

   while true do
      if not s then break end
      if not tab then 
         _, _, l, t, v = string.find(s, "glpi([_%w]+)|(%a):(.+)")
      else
         _, _, t, v = string.find(s, "(%a)[:;](.+)")
      end

      if t == "N" then
         _, _, v, s = string.find(v,";(.+)")
         v = t
      elseif t == "s" then
         _, _, _, v, s = string.find(v,"(%d+):\"([^;.*]*)\";(.+)")
      elseif t == "a" then
          _, _, _, v, s = string.find(v,"(%d+):(%b{})(.*)")
         v = string.strip(v,true)
      elseif t == "i" then
         _, _, v, s = string.find(v,"(%d*);(.+)")
         v = tonumber(v)
      elseif t == "b" then
         _, _, v, s = string.find(v,"(%d);(.+)")
         v = tonumber(v)
      else
         break
      end
      if not tab then 
         res["glpi"..l] = v
      else
         if cnt == 0 then
            cnt = cnt + 1
            b = v
         else
            cnt = 0
            -- Esta opcao ordena os indices numericos
            --if tonumber(b) then
            --   table.insert(res, v)
            --else
               res[b] = v
            --end
         end
      end
   end

   return res
end

local r = string.strip(s)
local t = table.dump(r)
--print(t)


--print(r.profiles[1].name)
