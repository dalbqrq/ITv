
local dado = require "dado"
local db = dado.connect ("ndoutils", "ndoutils", "itiv", "mysql")


----------------------------- DB ----------------------------------

-- Retorna tabela com nome dos campos de uma tabela sql
function select_columns (tablename)
	local t = {}

	cur = assert ( db:assertexec ("show columns from "..tablename))
	row = cur:fetch({}, "a")
	while row do
		table.insert(t, row.Field)
		row = cur:fetch(row,"a")
	end

	return t
end


