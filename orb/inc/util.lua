--[[

   TABLE
   CSV
   FILE
   OS

]]

loop = 500000


----------------------------- TABLE ----------------------------------

table.cat = function (t)
   local out
   for i, v in pairs(t) do
      if out then
         out = out.." , "..i.." = "..v
      else
         out = i.." = "..v
      end
   end
   return out
end


table.show = function (t)
   print( "{" )
   for i,v in pairs (t) do
      --print(("\n") )
      if type(v) == "table" then
         local vv = "{\n"
         for a,b in pairs(v) do
            vv = string.format ("%s  %s = \"%s\",\n", vv, a, tostring(b))
         end
         v = vv.." },"
         print( (string.format (" %s = %s", i, tostring(v))) )
      else
         print( (string.format (" %s = \"%s\",", i, tostring(v))) )
      end
   end
   if next(t) then
      --print( "\n" )
   end
   print( "}\n" )
end


table.dump = function (t)
   local s = ""
   local val = ""
   if #t > 0 then
      for _,row in ipairs(t) do
         dump(row)
      end
   else
      for field,val in pairs(t) do
         if type(val) == "string" then
            val = val:sub(1,60)
         end
	 s = s..field.."<"..type(val).."> = "..val
      end
   end
   return s
end


table.toString = function (t)
   local s = "{"
   for i,v in pairs (t) do
      s = s .. "\n"
      if type(v) == "table" then
         local vv = "{\n"
         for a,b in pairs(v) do
            --vv = string.format ("%s  %s = \"%s\",\n", vv, a, tostring(b))  -- with numbers naming the fields
            vv = string.format ("%s  \"%s\",\n", vv, tostring(b))
         end
         v = vv.." },"
         --s = s .. (string.format (" %s = %s", i, tostring(v)))   -- with numbers naming the fields
         s = s .. (string.format (" %s", tostring(v))) 
      else
         --s = s .. (string.format (" %s = \"%s\",", i, tostring(v)))  -- with numbers naming the fields
         s = s .. (string.format (" \"%s\",", tostring(v)))
      end
   end
   if next(t) then
      s = s .. "\n" 
   end
   s = s .. "}\n"

   return s
end

----------------------------- STRING ----------------------------------

string.toid = function (str)
   return string.gsub(string.gsub(str,"(%p+)"," "),"(%s+)","_")
end

string.extract_latlon = function(str)
   str = string.gsub(str, "%s+", "")

   -- tratar corretamente (converter) geotab no formato:  22°51'33.20"S,43°23'17.42"O
   -- agora simplesmente eliminaremos estas entradas.
   -- procurar expressao como esta em obj_info.lua:render_geotag()
   if string.find(str, "°") ~= nil or string.find(str, "'") ~= nil then
      return nil, nil
   end

   local lat, lon = nil, nil
   local b, c = string.find(str, ",")

   if b and c then
      lat = tonumber(string.sub(str,1,b-1))
      lon = tonumber(string.sub(str,b+1,-1))
   end

   if type(lat) == "number" and type(lon) == "number" then
      if lat < -180 or lat > 180 or lon < -90 or lon > 90 then
         lat, lon = nil, nil
      end
   else
      lat, lon = nil, nil
   end

   return lat, lon
end

----------------------------- ECT ----------------------------------

find_hostname = function( a, h, k ) 
   local host_name

   if a ~= "" and a ~= nil then host_name = a end
   if host_name == nil and h ~= "" and h ~= nil then host_name = h end
   if host_name == nil and k ~= "" and k ~= nil then host_name = k end

   return host_name
end


----------------------------- CSV ----------------------------------

-- Transform an array of strings into CSV 
function toCSV (t, sep)
   sep = sep or ','     -- ny default, use 'semi-colon' (,) as field delimiter instead of 'comma' (;)
   local s = ""
   local p

   for _,p in pairs(t) do
      s = s .. sep .. escapeCSV(p, sep)
   end
   return string.sub(s, 2)      -- remove first comma
end


-- If a string has commas or quotes inside, enclose it between quotes and escape its original quotes
function escapeCSV (s, sep)
   sep = sep or ','     -- use 'semi-colon' as field delimiter instead of 'comma'
   --local s = ""

   if string.find(s, '['..sep..'"]') then
      s = '"' .. string.gsub(s, '"', '""') .. '"'
   end
   return s
end


-- Transform a CSV line string into an array of strings
-- Return a table
function fromCSV (s, sep)
   sep = sep or ';'     -- use 'semi-colon' as field delimiter instead of 'comma'
   s = s .. sep
   local t = {}         -- table to collect fields
   local fieldstart = 1
   repeat
         if string.find(s, '^"', fieldstart) then        -- next field is quoted? (start with '"'?)
            local a, c
            local i = fieldstart
            repeat
               a, i, c = string.find(s, '"("?)', i+1)  -- find closing quote
            until c ~= '"'                              -- quote not followed by quote?
            if not i then error('unmatched "') end
            local f = string.sub(s, fieldstart+1, i-1)
            table.insert(t, (string.gsub(f, '""', '"')))
            fieldstart = string.find(s, sep, i) + 1
         else                                             -- unquoted; find next comma
            local nexti = string.find(s, sep, fieldstart)
            table.insert(t, string.sub(s, fieldstart, nexti-1))
            fieldstart = nexti + 1
         end
   until fieldstart > string.len(s)
   return t
end


----------------------------- FILE ----------------------------------

-- Return a table where each entry is a line
function line_reader(filename)

   --[[ OLD IMPLEMENTATION
   io.input(filename)
   local lines = {}
   -- read the lines in table 'lines'
   for line in io.lines() do
      table.insert(lines, line)
   end
   return lines
   ]]--

   local f = io.open(filename, "r")
   local lines = {}
   local line = ""

   if not f then return nil end

   while true do
      line = f:read("*line")
      if not line then 
         break 
      else
         table.insert(lines, line)
      end
   end
   f:close()

   return lines
end

function line_writer(filename, table_of_tables)
   -- Empty file
   local f = io.open(filename, 'w')
   f:close()

   f = io.open(filename, 'a')
   -- Append each table in CSV format to the file
   for _, v in ipairs(table_of_tables) do
      f:write(toCSV(v))
   end
   f:close()

end


function text_file_reader(filename)
   local f = io.open(filename, 'r')
   local text = f:read("*all")
   f:close()

   return text
end


function text_file_writer(filename, text)
   local f = io.open(filename, 'w')
   f:write(text)
   f:close()
end


----------------------------- OS ----------------------------------

function os.splittime(time_)
   D, H = math.modf( time_ / 24 / 60 / 60 )
   H, M = math.modf(H * 24)
   M, S = math.modf(M * 60)
   S, _ = math.modf(S * 60)

   return D, H, M, S
end


function os.capture(cmd, raw)
   local f = assert(io.popen(cmd, 'r'))
   local s = assert(f:read('*a'))
   f:close()
   if raw then return s end
   s = string.gsub(s, '^%s+', '')
   s = string.gsub(s, '%s+$', '')
   s = string.gsub(s, '[\n\r]+', ' ')
   return s
end


function os.sleep(seg)
   os.capture("sleep "..tonumber(seg))
end


function os.reset_monitor()
   return os.capture("/usr/sbin/invoke-rc.d nagios3 reload")
end


function os.reset_monitor_db()
   return os.capture("/usr/sbin/invoke-rc.d ndoutils restart")
end
