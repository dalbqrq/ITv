
require "Relats"
require "util"


t = {
 { 1,2,3,4 },
 { 5,6,7,8 },
 { 9,0,9,8 },
 { 7,6,5,4 }
}


for _,v in ipairs(t) do
   r = toCSV(v)
   print(r)
end

filename = "./t.csv"
line_writer(filename, t)

local month, year = 10, 2010

local clause = " and t.entities_id in (0, 24, 26)"
             .." and t.date like '"..year.."-"..month.."%'"
    clause = " and t.date like '"..year.."-"..month.."%'"
    --clause = ""

r = Relats.select_tickets(clause)
print(#r)
--line_writer(filename, t)

