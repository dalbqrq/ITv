
require "util"


local s = text_file_reader("/tmp/s2")
--local a, b, c, user_id = string.find(sess_, 'glpiID|s:(%d+):"(%d+)"')
--local d, e, f, user_name = string.find(sess_, 'glpiname|s:(%d+):"([%w-_%.]+)";')

print(s)
print("----------------------------------------------\n\n")

print("label", "type", "size", "value")
for l, t, z, v in string.gfind(s, "glpi([_%w]+)|(%a):(%d+):([^;]);") do
   print(l, t, z, v)
end

