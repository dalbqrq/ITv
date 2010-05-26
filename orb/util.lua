
----------------------------- UTIL ----------------------------------

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

