
require "Model"

local t = show_columns("itvision_app")

for i,v in pairs(t) do
	print(i, v.Field, v.Key)
end

