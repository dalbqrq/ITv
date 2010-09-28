
require 'util'


function activate_app(app, objs)
   app = app[1]
   s = ""

   for i, v  in ipairs(objs) do
      if s then s = s.." & " end
      s = s..v.name1
      if v.name2 then s = s..";"..v.name2 end
   end

   s = app.name.." = "..s.."\n"
   s = s.."display 0;"..app.name..";"..app.name

   text_file_writer("/tmp/out", s)

end
