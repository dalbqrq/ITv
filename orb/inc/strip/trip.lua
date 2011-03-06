
require "util"

local s

s = "5:{DANIEL}LINS"
s = "5:{DANIEL:4:{DE:a:{ALB}MAIS:X}}LINS"
s = "5:{}MAIL|a:1:{5:{DANIEL}LINS}LINS|a:4:{DALB|s:1;GLPI|a:1:{XAXAXA}}DE|i:1;"
i, j, z, s, r = string.find(s,"(%d+):({[^{^}.*]*})(.+)")
print(i, j, z, s, "\n", r)




--[[
i, j, z, v, r = string.find(s,"(%d+):({[^{^}.]*})(.+)")
print(i, j, z, v, r)

if not v then return 0 end
_, _, f = string.gsub(v,"[%{%}]", "")
print(f)

s = string.gsub(s,v,"XX")
i, j, z, v, r = string.find(s,"(%d+):({[^{^}.]*})(.+)")
print(i, j, z, v, r)

if not v then return 0 end
_, _, f = string.gsub(v,"[%{%}]", "")
print(f)

s = string.gsub(s,v,"XX")
i, j, z, v, r = string.find(s,"(%d+):({[^{^}.]*})(.+)")
print(i, j, z, v, r)
_, _, f = string.gsub(v,"[%{%}]", "")
print(f)
]]
