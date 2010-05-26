module (..., package.seeall);

local db_config = {
	instance_id = 1,
 	dbname = "ndoutils", 
	dbuser = "ndoutils", 
	dbpass = "itv", 
	driver = "mysql"
}

local dado = require "dado"
local inst = " instance_id = "..db_config.instance_id
local cond = ""

local objecttype = {
	"Host",					-- 1
	"Service",				-- 2
	"Host group",				-- 3
	"Service group",			-- 4
	"Host escalation",			-- 5
	"Service escalation",			-- 6
	"Host dependency",			-- 7
	"Service dependency",			-- 8
	"Timeperiod",				-- 9
	"Contact",				-- 10
	"Contact group",			-- 11
	"Command",				-- 12
	"Extended host info (deprecated)",	-- 13
	"Extended service info (deprecated)"	-- 14
}


----------------------------- CONFIG ----------------------------------


function connect ()
	local c = db_config
	return dado.connect (c.dbname, c.dbuser, c.dbpass, c.driver)
end


function get_bp_id () -- usado para selecionar os 'services' que sao aplicacoes
	local db = connect ()
	local content = db:selectall ("object_id", "nagios_objects", "name1 = 'check_bp_status'")
	return content[1].object_id
end


function select_columns (table_) -- Retorna tabela com nome dos campos de uma tabela sql
	local content = {}
	local cur = assert ( db:assertexec ("show columns from "..table_))
	local row = cur:fetch ({}, "a")

	while row do
		table.insert (t, row.Field)
		row = cur:fetch (row,"a")
	end
	return content
end


--[[ TODO: esta funcao deve estar em outra camada de acesso
function init_config ()
	local db = connect ()
	local content = db:selectall ("config_id", "itvision_config")

	if content[1] == nil then
		assert ( db:assertexec ( "INSERT INTO itvision_config (instance_id, created, updated, version, home_dir) " ..
				"VALUES ( "..instance_id.." now(), now(), '0.9', '/usr/local/itvision');")
		return true
	else
		return false
	end
	db:close ()
end
]]


----------------------------- DB ACCESS ----------------------------------


function set_instance (inst_) -- change instance to be included in condition stmt
	if inst_ then
		inst = " instance_id = "..inst_
	else
		inst = " instance_id > 0 "
	end
end


function set_cond (cond_) -- include instance condition
	if cond_ then 
		cond = cond_.." and ".. inst 
	else 
		cond = inst 
	end
end


function select (table_, cond_, extra_)
	local db = connect ()
	local cond = set_cond (cond_)
	local content = db:selectall ("*", table_, cond_, extra_)
	db:close ()
	return content
end


function select_func (table_, cond_) -- this function return another function
        local db = connect ()
	local cond = set_cond (cond_)
        local content = db:select ("*", table_, cond_)
	-- Exemplo de uso:
	--   for field1, field2 in content do print (field1, field2) end     
        --   print (type (t))
        db:close ()
        return content
end

function insert (table_, content_)
	local db = connect ()
	content_.instance_id = db_config.instance_id -- nao insere outras instancias
	assert ( db:insert (table_, content_))
	db:close ()
end


function update (table_, content_, cond_)
	local db = connect ()
	cond_ = set_cond (cond_)
	content_.instance_id = db_config.instance_id -- nao atualiza outras instancias
	assert ( db:update (table_, content_, cond_))
	db:close ()
end


function delete (table_, cond_)
	local db = connect ()
	local cond = set_cond (cond_)
	assert ( db:update (table_, cond_))
	db:close ()
end


function execute (stmt_)
	local db = connect ()
	assert ( db:assertexec (stmt_))
	db:close ()
end


